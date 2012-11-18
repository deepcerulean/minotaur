require 'rspec'

require "minotaur"
include Minotaur

describe Grid do
  let(:width)   { 20 }
  let(:height)  { 20 }

  subject do
    Grid.new(width, height)
  end

  its(:width)   { should eql(width) }
  its(:height)  { should eql(height) }

  context "passage handling" do
    let(:origin) { Position.origin }
    let(:destination) { Position.origin.translate(EAST) }

    describe "creating a passage" do
      before(:each) do
        subject.build_passage!(origin,destination)
      end

      it "should be passable one way" do
        subject.passable?(origin,destination).should be_true
      end

      it "should be passable the other" do
        subject.passable?(destination,origin).should be_true
      end

      it "should not be passable in other directions" do
        subject.passable?(origin,origin.translate(SOUTH)).should be_false
      end
    end
  end

  describe "#to_s" do
    context "without a path" do
      describe "a tiny grid" do
        let(:width)  { 1 }
        let(:height) { 1 }
        its(:to_s) { should eql(" _\n|_|\n") }
      end
      describe "a 2x2 grid" do
        let(:width) { 2 }
        let(:height) { 2 }
        its(:to_s) { should eql(" ___\n|_|_|\n|_|_|\n")}
      end
    end
    context "with a path" do
      describe "a tiny grid with a path" do
        let(:width)  { 1 }
        let(:height) { 1 }
        let(:path)   { [Position.origin] }
        it "should draw the path" do
          subject.to_s(path).should eql(" _\n|a|\n")
        end
      end
    end
  end


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

  pending "some more/better tests"

end