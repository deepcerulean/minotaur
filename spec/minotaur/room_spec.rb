require "spec_helper"

describe Room do
  let(:location) { origin }

  describe "attributes" do
    subject do
      Room.new(location:location,width:width,height:height)
    end

    let(:width)    { 13 }
    let(:height)   { 11 }

    its(:width) { should eql(width) }
    its(:height) { should eql(height) }
    its(:location) { should eql(location) }
  end

  describe "#adjacent_direction" do

    subject do
      room = Room.new(location:location,width:width,height:height)
      other_room = Room.new(location:other_location, width:other_width, height:other_height)

      room.adjoining_direction(other_room)
    end

    context "when the other room is to the east" do
      let(:location) { origin }
      let(:width)    { 2 }
      let(:height)   { 2 }

      let(:other_location) { origin.translate(EAST,2) }
      let(:other_width)    { 2 }
      let(:other_height)   { 2 }

      it { should eql(EAST) }
    end

    context "when the other room is to the south" do
      let(:location) { origin }
      let(:width)    { 2 }
      let(:height)   { 2 }

      let(:other_location) { origin.translate(SOUTH,2) }
      let(:other_width)    { 2 }
      let(:other_height)   { 2 }

      it { should eql(SOUTH) }
    end


    context "when the other room is to the west" do
      let(:location) { origin }
      let(:width)    { 2 }
      let(:height)   { 2 }

      let(:other_location) { origin.translate(WEST,2) }
      let(:other_width)    { 2 }
      let(:other_height)   { 2 }

      it { should eql(WEST) }
    end

    context "when the other room is to the north" do
      let(:location) { origin }
      let(:width)    { 2 }
      let(:height)   { 2 }

      let(:other_location) { origin.translate(NORTH,2) }
      let(:other_width)    { 2 }
      let(:other_height)   { 2 }

      it { should eql(NORTH) }
    end
  end

  describe "#shared_edge" do
    subject do
      room       = Room.new(location:location,width:width,height:height)
      other_room = Room.new(location:other_location, width:other_width, height:other_height)

      room.adjoining_edge(other_room)
    end

    context "when the other room is to the east" do
      let(:location) { origin }
      let(:width)    { 2 }
      let(:height)   { 2 }

      let(:other_location) { origin.translate(EAST,2) }
      let(:other_width)    { 2 }
      let(:other_height)   { 2 }

      describe "when directly overlapping" do
        it { should eql([[[1, 0], [2, 0]], [[1, 1], [2, 1]]]) }
      end

      describe "when partially overlapping" do
        let(:other_location) { origin.translate(EAST,2).translate(SOUTH, 1) }
        it { should_not be_nil }
        it { should have(1).item }
        it { should eql([[[1, 1], [2, 1]]]) }
      end
    end
  end



  describe "the result of a #subdivide" do
    subject do
      room = Room.new(location: location, width: width, height: height)
      room.subdivide(direction: direction, recursive: recursive, min_subdivision_length: minimum)
    end

    context "when subdividing once" do
      let(:width)     { 13 }
      let(:height)    { 11 }
      let(:recursive) { false }
      let(:minimum)   { 5 }

      describe "given a vertical split" do
        let(:direction) { 'vertical' }

        it { should_not be_empty }
        it { should have(2).items }

        it "should be two particular smaller rooms" do
          room_dimensions = subject.map do |room|
            { width: room.width, height: room.height }
          end

          first_room,second_room = room_dimensions[0], room_dimensions[1]

          first_room[:width].should eql(6)
          first_room[:height].should eql(11)
          second_room[:width].should eql(7)
          second_room[:height].should eql(11)
        end
      end

      describe "given a horizontal split" do
        let(:direction) { 'horizontal' }
        it { should_not be_empty }
        it { should have(2).items }
        it "should be two particular smaller rooms" do
          room_dimensions = subject.map { |r| {location: Position.new(r.x, r.y), width: r.width, height: r.height} }
          first_room,second_room = room_dimensions[0],room_dimensions[1]

          first_room[:location].should eql(origin)
          first_room[:width].should eql(13)
          first_room[:height].should eql(5)

          second_room[:location].should eql(origin.translate(SOUTH,5))
          second_room[:width].should eql(13)
          second_room[:height].should eql(6)
        end
      end
    end

    context "when subdividing a 6x6 grid recursively" do
      let(:width)     { 6 }
      let(:height)    { 6 }
      let(:recursive) { true }
      let(:direction) { 'horizontal' }


      describe "given a minimum edge length of 3" do
        let(:minimum) { 3 }
        it { should have(4).items }
        #it { should eql([]) }
      end
    end
  end
end