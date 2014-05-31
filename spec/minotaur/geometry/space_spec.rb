require 'spec_helper'
require 'pry'
include Minotaur::Geometry
include Minotaur::Support::DirectionHelpers

describe Space do
  subject do
    Space.new x: 1, y: 1, width: 3, height: 3
  end

  it 'should indicate edges' do
    subject.northern_edge.should eql([
      Position.new(1,1), Position.new(2,1), Position.new(3,1)
    ])
  end

  it 'should indicate outer edges' do
    subject.outer_edge_for(NORTH).should eql([
      Position.new(1,0), Position.new(2,0), Position.new(3,0)
    ])
  end

end
