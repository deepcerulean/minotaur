require 'spec_helper'

include Minotaur::Geometry
include Minotaur::Geometry::Directions
include Minotaur::Helpers::PositionHelpers
include Minotaur::Helpers::DirectionHelpers

describe Grid do
  let(:width)   { 20 }
  let(:height)  { 20 }

  subject do
    Grid.new(width: width, height: height)
  end

  its(:width)   { should eql(width) }
  its(:height)  { should eql(height) }

  let(:direction) { direction_from start, destination }

  context "passage handling" do
    let(:start) { origin }
    let(:destination) { origin.translate(EAST) }

    describe "creating a passage" do
      before(:each) do
        subject.build_passage!(start,destination)
      end

      it "should be passable one way" do
        subject.passable?(start,direction).should be_true
      end

      it "should be passable the other" do
        subject.passable?(destination,direction_opposite(direction)).should be_true
      end

      it "should not be passable in other directions" do
        subject.passable?(start,SOUTH).should be_false
      end
    end
  end

  #describe "#to_s" do
  #  context "without a path" do
  #    describe "a tiny grid" do
  #      let(:width)  { 1 }
  #      let(:height) { 1 }
  #      #its(:to_s) { should eql(" _\n|_|\n") }
  #      its(:to_s) { should eql("\n/---|\n|   |\n|---|\n") }
  #    end
  #    describe "a 2x2 grid" do
  #      let(:width) { 2 }
  #      let(:height) { 2 }
  #      #its(:to_s) { should eql(" ___\n|_|_|\n|_|_|\n")}
  #      its(:to_s) { should eql("\n/---|---|\n|   |   |\n|---|---|\n|   |   |\n|---|---|\n") }
  #    end
  #  end
  #  context "with a path" do
  #    describe "a tiny grid with a path" do
  #      let(:width)  { 1 }
  #      let(:height) { 1 }
  #      let(:path)   { [Position.origin] }
  #      it "should draw the path" do
  #        #subject.to_s(path).should eql(" _\n|a|\n")
  #        subject.to_s(path).should eql("\n/---|\n| a |\n|---|\n")
  #      end
  #    end
  #  end
  #end


  context "determines adjacent positions" do
    describe "#passable_adjacent_to" do
      context "determines one passable adjacent position" do
        let(:width)  { 3 }
        let(:height) { 3 }
        before(:each) do
          subject.build_passage!(Position.origin, Position.origin.translate(EAST))
        end
        it "should report exactly one adjacent position" do
          subject.passable_adjacent_to(Position.origin).should eql([Position.origin.translate(EAST)])
        end
      end
    end
  end
end