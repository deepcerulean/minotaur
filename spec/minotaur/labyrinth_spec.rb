require "rspec"
require 'minotaur'

WIDTH = 3
HEIGHT = 3

describe Minotaur::Labyrinth do
  let(:width)      { WIDTH }
  let(:height)     { HEIGHT }

  let(:extruder) do
    Minotaur::Extruders::RecursiveBacktrackingExtruder
  end

  let(:pathfinder) do
    Minotaur::Pathfinders::RecursiveBacktrackingPathfinder
  end

  subject do
    Minotaur::Labyrinth.new(
      width:      width,
      height:     height,
      extruder:   extruder,
      pathfinder: pathfinder
    )
  end

  before(:each) do
    subject.carve_passages!
  end

  context "when extruding a labyrinth" do
    describe "the resultant grid" do
      its(:width)  { should eql width }
      its(:height) { should eql height }
      context "should be everywhere connected" do
        Minotaur::Grid.each_position(WIDTH,HEIGHT) do |src|
          Minotaur::Grid.each_position(WIDTH,HEIGHT) do |dst|
            if src != dst
              it "should be connected between #{src} and #{dst}" do
                subject.path_between?(src,dst).should be_true
              end
            end
          end
        end
      end
    end
  end
end