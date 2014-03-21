require 'spec_helper'
require 'pry'

describe Minotaur::Region do
  subject { Minotaur::Region.new(x: 1, y: 1, width: 4, height: 4) }
  it 'should map perimeter' do
    subject.perimeter.each do |point|
      subject.perimeter?(point).should be_true
    end
  end

  it 'should indicate center' do
    subject.center.should eql(Minotaur::Geometry::Position.new(3,3))
  end

  it 'should map outer corners' do
    subject.outer_corners.should eql(
      [Minotaur::Geometry::Position.new(0,0),
       Minotaur::Geometry::Position.new(0,5),
       Minotaur::Geometry::Position.new(5,0),
       Minotaur::Geometry::Position.new(5,5)])
  end
end

