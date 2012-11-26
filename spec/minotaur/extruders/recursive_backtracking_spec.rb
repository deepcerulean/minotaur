require "spec_helper"

include Minotaur::Extruders

describe RecursiveBacktrackingExtruder do
  subject { RecursiveBacktrackingExtruder }

  let(:labyrinth) do
    Minotaur::Labyrinth.new(width: width, height: height, extruder: subject)
  end

  context "when carving passages for a labyrinth" do
    #let(:width)  { 5 }
    #let(:height) { 5 }
    #describe "a normal maze" do
    #  it "is awesome" do
    #    labyrinth.extrude!
    #    puts labyrinth
    #  end
    #end

    context "should extrude passages" do
      describe "an atomic maze" do
        let(:width)  { 1 }
        let(:height) { 1 }

        it "should leave a 1x1 grid alone" do
          labyrinth.extrude!
          labyrinth.rows.should == [[0]]
        end
      end
    end
  end
end
