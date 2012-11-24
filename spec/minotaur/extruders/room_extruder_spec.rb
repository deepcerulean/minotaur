require "spec_helper"

describe Extruders::RoomExtruder do
  subject do
    Extruders::RoomExtruder
  end

  let(:labyrinth) do
    Labyrinth.new(size: size, extruder:subject, prettifier: Prettifier::CompactPrettifier)
  end

  context "when placing rooms for a dungeon" do
    let(:size)            { 40 }
    let(:min_edge_length) { 5 }
    let(:variance)        { 2  }

    before(:each) do
      labyrinth.extrude!(min_edge_length: min_edge_length, variance: variance)
    end

    it "should have more than 80% 'open' space" do
      puts labyrinth
      total = labyrinth.all_positions.count
      total_open = labyrinth.all_positions.count { |position| labyrinth.open?(position) }
      (total_open.to_f/total).should >= 0.8
      # TODO note this seems to be returning true for 100% of the grid, which can't/shouldn't be the case

      # average room size should be greater than min room size
      # alternatively, NO rooms should have less than min room size
    end

    it "should have no unconnected rooms" do
      puts labyrinth
      labyrinth.rooms.each do |room|
        labyrinth.doors.any? do |door|
          room == door[0] || room == door[1]
        end.should be_true
      end
    end

    it "should have rooms that obey the minimum edge/area length guidelines" do
      labyrinth.rooms.each do |room|
        room.height.should >= min_edge_length
        room.width.should  >= min_edge_length
        (room.height*room.width).should >= min_edge_length**2
      end
    end
  end
end