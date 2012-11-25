require "spec_helper"

#include Minotaur
#include Minotaur::Extruders
#include Minotaur::Helpers::PositionHelpers
#include Minotaur::Prettifier


describe RoomExtruder do
  subject do
    RoomExtruder
  end

  let(:labyrinth) do
    Labyrinth.new(size: size, extruder:subject, prettifier: CompactPrettifier)
  end

  context "when placing rooms for a dungeon" do
    let(:size)            { 40 }
    let(:min_edge_length) { 5 }
    let(:variance)        { 2  }

    before(:each) do
      labyrinth.extrude!(min_edge_length: min_edge_length, variance: variance)
    end


    it "should have rooms that obey the minimum edge/area length guidelines" do
      #puts labyrinth
      labyrinth.rooms.each do |room|
        room.height.should >= min_edge_length
        room.width.should  >= min_edge_length
        (room.height*room.width).should >= min_edge_length**2
      end
    end

    it "should have more than 70% 'open' space" do
      puts labyrinth
      total = labyrinth.all_positions.count
      total_open = labyrinth.all_positions.count { |position| labyrinth.open?(position) }
      (total_open.to_f/total).should >= 0.7
    end

    it "should have doors" do labyrinth.doors.should_not be_empty end

    it "should have no unconnected rooms" do
      #puts labyrinth
      labyrinth.rooms.each do |room|
        labyrinth.doors.any? do |door|
          room == door[0] || room == door[1]
        end.should be_true
      end
    end
  end
end