require "rspec"
require 'minotaur'

WIDTH = 5
HEIGHT = 5

describe Minotaur::Labyrinth do
  let(:width)      { WIDTH }
  let(:height)     { HEIGHT }

  let(:extruder) do
    Minotaur::Extruders::RecursiveBacktrackingExtruder.new
  end

  let(:pathfinder) do
    Minotaur::Pathfinders::RecursiveBacktrackingPathfinder.new
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
    puts subject.to_s
  end

  context "when extruding a labyrinth" do
    describe "the resultant grid" do
      its(:width) { should eql width }
      its(:height) { should eql height }

      # TODO real tests
      pending "some real tests"

      #context "should be everywhere connected" do
      #  MAX_DISTANCE = WIDTH*HEIGHT # worst case should be have to traverse WHOLE AREA to get there
      #  Minotaur::Grid.each_position(WIDTH,HEIGHT) do |src|
      #    Minotaur::Grid.each_position(WIDTH,HEIGHT) do |dst|
      #      if src != dst
      #        it "should be connected between #{src} and #{dst}" do
      #          subject.path_between(src,dst).should <= MAX_DISTANCE
      #        end
      #      end
      #    end
      #  end
        #width.times do |x|
        #  height.times do |y|
        #    width.times do |bx|
        #      height.times do |by|
        #
        #      end
        #    end
        #  end
        #end
      #end

      #context "should be everywhere connected" do
      #  #subject.all do |values|
      #  #
      #  #end
      #  #SIZE.times do
      #end


      #context "rows" do
      #  its(:rows) { should be_an Enumerable }
      #end
      #context "should be everywhere connected" do
      #  SIZE.times do |ax|
      #    SIZE.times do |ay|
      #      SIZE.times do |bx|
      #        SIZE.times do |by|
      #          #it { should be_connected(ax,ay,bx,by) }
      #          it "should be connected between #{ax},#{ay} and #{bx},#{by}" do
      #            subject.connected?(ax,ay,bx,by).should be_true
      #          end
      #        end
      #      end
      #    end
      #  end
      #end
    end
  end
end