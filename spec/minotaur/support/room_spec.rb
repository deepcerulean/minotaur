require "spec_helper"

describe Minotaur::Room do
  let(:location) { origin }

  describe "attributes" do
    subject do
      Minotaur::Room.new(location,width,height)
    end

    let(:width)    { 13 }
    let(:height)   { 11 }

    its(:width) { should eql(width) }
    its(:height) { should eql(height) }
    its(:location) { should eql(location) }
  end

  describe "the result of a #split" do
    subject do
      room = Minotaur::Room.new(location,width,height)
      split_results = room.split!(direction: direction, recursive: recursive, min_edge_length: minimum)
      p split_results
      split_results
    end

    context "when subdividing once" do
      let(:width)    { 13 }
      let(:height)   { 11 }
      let(:recursive) { false }
      let(:minimum) { 5 }

      describe "given a vertical split" do
        let(:direction) { 'vertical' }

        it { should_not be_empty }
        it { should have(2).items }

        it "should be two particular smaller rooms" do
          room_dimensions = subject.map do |room|
            [ room.width, room.height ]
          end

          room_dimensions.should eql([[13,5],[13,6]])
        end
      end

      describe "given a horizontal split" do
        let(:direction) { 'horizontal' }
        it { should_not be_empty }
        it { should have(2).items }
        it "should be two particular smaller rooms" do
          room_dimensions = subject.map { |r| [r.width, r.height] }
          room_dimensions.should eql([[6,11],[7,11]])
        end
      end
    end

    context "when subdividing a 6x6 grid recursively" do
      let(:width)     { 6 }
      let(:height)    { 6 }
      let(:recursive) { true }
      let(:direction) { 'horizontal' }
      describe "given a minimum edge length of 3" do
        let(:minimum)   { 3 }
        #it { should_not be_empty }
        it { should have(4).items }
      end
    end
  end
end