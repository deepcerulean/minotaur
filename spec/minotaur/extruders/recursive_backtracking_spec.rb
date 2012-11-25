require "spec_helper"

include Minotaur::Extruders

describe RecursiveBacktrackingExtruder do
  subject { RecursiveBacktrackingExtruder }

  let(:labyrinth) do
    Minotaur::Labyrinth.new(size: size, extruder:subject)
  end

  context "when carving passages for a labyrinth" do
    #let(:size) { 25 }
    #describe "a normal maze" do
    #  it "is awesome" do
    #    labyrinth.extrude!
    #    puts labyrinth
    #  end
    #end

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