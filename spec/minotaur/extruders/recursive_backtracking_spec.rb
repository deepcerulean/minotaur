require "rspec"
require 'minotaur'

describe Minotaur::Extruders::RecursiveBacktrackingExtruder do
  subject do
    Minotaur::Extruders::RecursiveBacktrackingExtruder
  end

  let(:labyrinth) do
    Minotaur::Labyrinth.new(size: size, extruder:subject)
  end

  context "when carving passages for a labyrinth" do
    let(:size) { 10 }

    context "should extrude passages" do
      describe "an atomic maze" do
        let(:size) { 1 }

        it "should leave a 1x1 grid alone" do
          labyrinth.extrude!
          labyrinth.rows.should == [[0]]
        end
      end
    end
  end
end