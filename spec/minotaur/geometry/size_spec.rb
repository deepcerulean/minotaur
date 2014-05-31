require 'spec_helper'
require 'minotaur/geometry/size'

describe Minotaur::Geometry::Size do
  subject { Minotaur::Geometry::Size.new(width: width, height: height) } 
  let(:width)  { 2 }
  let(:height) { 2 }
  its(:area) { should eql(width*height) }

  # it 'has an area' do

  # end
end
