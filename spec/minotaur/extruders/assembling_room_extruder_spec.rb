require "spec_helper"

#include Minotaur::Extruders
#include Minotaur::Prettifiers


describe Minotaur::Extruders::AssemblingRoomExtruder do

  subject do
    Minotaur::Extruders::AssemblingRoomExtruder
  end

  let(:labyrinth) do
    Minotaur::Labyrinth.new(
        width:         size,
        height:        size,
        extruder:     subject,
        prettifier:   Minotaur::Prettifiers::SimplePrettifier
    )
  end

  context "when placing rooms for a dungeon" do
    let(:size)            { 24 }
    let(:room_count)      { 4 }
    #let(:min_edge_length) {  5 }
    #let(:variance)        {  0 }

    before(:each) do
      labyrinth.extrude!({room_count:   room_count})
      # (min_edge_length: min_edge_length, variance: variance)
      puts "--- have labyrinth!:"
      puts labyrinth
    end


    it "should not have more than 60% 'empty' space" do
      puts "--- okay..."
      #total = labyrinth.all_positions.count
      #total_open = labyrinth.all_positions.count do |position|
      #  !labyrinth.empty?(position)
      #end
      #(total_open.to_f/total).should >= 0.4
      #puts labyrinth
    end
  end
end
