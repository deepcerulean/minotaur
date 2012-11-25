require "spec_helper"

describe RoomExtruder do
  subject do
    RoomExtruder
  end

  let(:labyrinth) do
    Labyrinth.new(
      width:        size,
      height:       size,
      extruder:     subject,
      prettifier:   CompactPrettifier
    )
  end

  context "when placing rooms for a dungeon" do
    let(:size)            { 40 }
    let(:min_edge_length) {  5 }
    let(:variance)        {  0 }

    before(:each) do
      labyrinth.extrude!(min_edge_length: min_edge_length, variance: variance)
    end

    it "should have rooms that obey the minimum edge/area length guidelines" do
      labyrinth.rooms.each do |room|
        room.height.should >= min_edge_length
        room.width.should  >= min_edge_length
        (room.height*room.width).should >= min_edge_length**2
      end
    end

    it "should have more than 40% 'open' space" do
      total = labyrinth.all_positions.count
      total_open = labyrinth.all_positions.count { |position| labyrinth.open?(position) }
      (total_open.to_f/total).should >= 0.4
    end

    it "should have doors" do labyrinth.doors.should_not be_empty end

    it "should have no unconnected rooms" do
      labyrinth.rooms.each do |room|
        labyrinth.doors.any? do |door|
          room == door[0] || room == door[1]
        end.should be_true
      end
    end
  end
end