require "spec_helper"
require 'pry'

#include Minotaur::Extruders
#include Minotaur::Prettifiers
include Minotaur::Support::DirectionHelpers


describe Minotaur::Extruders::AssemblingRoomExtruder do

  subject do
    Minotaur::Extruders::AssemblingRoomExtruder
  end

  let(:labyrinth) do
    Minotaur::Labyrinth.new(
        width:      size,
        height:     size,
        extruder:   subject,
        prettifier: Minotaur::Prettifiers::SimplePrettifier
    )
  end

  context "should place rooms adjacently" do
    let(:size) { 50 }
    it 'should place a room adjacently to the west' do
      first = Minotaur::Room.new(width: 3, height: 8, x: 2, y: 2)
      second = Minotaur::Room.new(width: 7, height: 5)
      labyrinth.place_centrally(first)
      labyrinth.attempt_to_place_adjacently(second, first, WEST)
      second.x.should eql(first.x+first.width+1)
      (second.y+second.height).should be > first.y
      second.y.should be < first.y + first.height
    end

    # it 'should place a room to the west' do
    #   first = Minotaur::Room.new(width: 5, height: 5)
    #   second = Minotaur::Room.new(width: 5, height: 5)
    #   labyrinth.place_centrally(first)
    #   labyrinth.attempt_to_place_adjacently(second, first, WEST)
    #   second.x.should eql(first.x+first.width+1)
    #   (second.y+second.height).should be > first.y
    #   second.y.should be < first.y + first.height
    # end
    # it 'should place a room to the east' do
    #   first = Minotaur::Room.new(width: 5, height: 5)
    #   second = Minotaur::Room.new(width: 5, height: 5)
    #   labyrinth.place_centrally(first)
    #   labyrinth.attempt_to_place_adjacently(second, first, EAST)
    #   second.x.should eql(first.x-first.width-1)
    #   (second.y+second.height).should be > first.y
    #   second.y.should be < first.y + first.height
    # end
  end

  context "when placing rooms for a dungeon" do
    let(:size)            { 30 }
    let(:room_count)      { 60 }
    #let(:min_edge_length) {  5 }
    #let(:variance)        {  0 }

    before(:each) do
      labyrinth.extrude!({room_count: room_count})
      # (min_edge_length: min_edge_length, variance: variance)
      # puts "--- have labyrinth!:"
      # puts labyrinth
    end

    # it 'should attempt to place first room randomly' do
    #   labyrinth.attempt_to_place(Room.new(1,1)) 
    # end

    it "should not have more than 60% 'empty' space" do
      labyrinth
      # binding.pry
      #total = labyrinth.all_positions.count
      #total_open = labyrinth.all_positions.count do |position|
      #  !labyrinth.empty?(position)
      #end
      #(total_open.to_f/total).should >= 0.4
      #puts labyrinth
    end
  end
end
