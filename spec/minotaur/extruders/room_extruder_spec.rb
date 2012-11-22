require "rspec"
require 'minotaur'

describe Minotaur::Extruders::RoomExtruder do
  subject do
    Minotaur::Extruders::RoomExtruder
  end

  let(:labyrinth) do
    Minotaur::Labyrinth.new(size: size, extruder:subject)
  end

  context "when placing rooms for a dungeon" do
    let(:size) { 50 }

    before(:each) do
      labyrinth.extrude!
    end

    describe "most of the space should be open" do
      it "has more than 80% 'open' space" do
        puts labyrinth
        total = labyrinth.all_positions.count
        total_open = labyrinth.all_positions.count { |position| labyrinth.open?(position) }

        #p (total_open.to_f/total)
        (total_open.to_f/total).should >= 0.8
        # TODO note this seems to be returning true for 100% of the grid, which can't/shouldn't be the case

      end
    end
  end
end
