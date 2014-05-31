require 'spec_helper'
require 'pry'
include Minotaur::Support
include Minotaur::Support::PositionHelpers
include Minotaur::Geometry

describe PositionHelpers do
  context "#distance_between" do
    it 'should calculate Pythagorean distance' do
      a,b = Position.new(0,3), Position.new(4,0)
      distance_between(a,b).should eql(5.0)
    end
  end
end
