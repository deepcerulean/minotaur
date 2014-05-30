require "spec_helper"
require 'pry'

include Minotaur::Support::DirectionHelpers

describe Minotaur::Extruders::AssemblingRoomExtruder do
  subject do
    Minotaur::Extruders::AssemblingRoomExtruder
  end

  let(:labyrinth) do
    Minotaur::Labyrinth.new(width: size, height: size, extruder: subject)
  end

  context "should place rooms adjacently" do
    let(:size) { 20 }

    it 'should place a room adjacently to another room' do
      first = Minotaur::Room.new(width: 3, height: 6)
      second = Minotaur::Room.new(width: 4, height: 8)

      labyrinth.place_centrally(first)
      first.should be_placed

      labyrinth.attempt_to_place_adjacently(second, first, WEST)
      second.should be_placed

      second.x.should eql(first.x-second.width-1)
      (second.y+second.height).should be > first.y
      second.y.should be < first.y + first.height
    end
  end

  context "when extruding a dungeon" do
    let(:size)            { 20 }
    let(:room_count)      { 10 }

    before(:each) do
      labyrinth.extrude!({room_count: room_count})
      # puts
      # puts labyrinth.to_s
    end

     it "should extrude doors" do
      labyrinth.should have(labyrinth.rooms.count-1).doors
    end
  end
end
