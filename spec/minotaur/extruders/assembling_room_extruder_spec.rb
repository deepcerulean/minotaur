require "spec_helper"

#include Minotaur::Extruders
#include Minotaur::Prettifiers


describe Minotaur::Extruders::AssemblingRoomExtruder do

  subject do
    Minotaur::Extruders::AssemblingRoomExtruder
  end

  let(:labyrinth) do
    Minotaur::Labyrinth.new(
        size:         size,
        #height:       size,
        extruder:     subject
        #prettifier:   Minotaur::Prettifiers::CompactPrettifier
    )
  end

  context "when placing rooms for a dungeon" do
    let(:size)            { 40 }
    let(:room_count)      { 9 }
    #let(:min_edge_length) {  5 }
    #let(:variance)        {  0 }

    before(:each) do
      labyrinth.extrude! #(min_edge_length: min_edge_length, variance: variance)
      puts labyrinth
    end

    #it "should have rooms that obey the minimum edge/area length guidelines" do
    #  labyrinth.rooms.each do |room|
    #    room.height.should >= min_edge_length
    #    room.width.should  >= min_edge_length
    #    (room.height*room.width).should >= min_edge_length**2
    #  end
    #end

    it "should have more than 40% 'open' space" do
      total = labyrinth.all_positions.count
      total_open = labyrinth.all_positions.count { |position| labyrinth.open?(position) }
      (total_open.to_f/total).should >= 0.4
    end
  end
end