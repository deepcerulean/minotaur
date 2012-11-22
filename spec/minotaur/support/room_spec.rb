require "rspec"
require 'minotaur'

#
describe Minotaur::Room do
  #
  subject do
    Minotaur::Room.new(location,width,height)
  end

  let(:location) { Minotaur::Position.origin }


  context "should subdivide once" do
    let(:width)    { 13 }
    let(:height)   { 11 }
    # ...
    its(:width) { should eql(width) }
    its(:height) { should eql(height) }
    its(:location) { should eql(location) }

    it "should subdivide into two smaller rooms" do
      #subject.subdivide direction: 'horizontally'
      smaller_rooms = subject.split!(direction: 'vertical', recursive: false)
      #p smaller_rooms
      smaller_rooms.should_not be_empty
      smaller_rooms.map { |room| [ room.width, room.height] }.should eql([[13,5],[13,6]])

    end

    it "should subdivide into two smaller rooms" do
      smaller_rooms = subject.split!(direction: 'horizontal', recursive: false)
      smaller_rooms.should_not be_empty
      smaller_rooms.map { |room| [room.width, room.height]}.should eql([[6,11],[7,11]])
    end

  end

  context "should subdivide recursively" do
    let(:width) { 6 }
    let(:height) { 6 }
    #let(:location) { Position.origin }
    it "should dividie into four smaller rooms" do
      smaller_rooms = subject.split!(recursive: true, min: 3)
      smaller_rooms.should_not be_empty
      smaller_rooms.should have(4).items
    end
  end
end