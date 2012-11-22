require "rspec"
require 'minotaur'

describe Minotaur::Scalar do
  #
  it "can split an uneven magnitude into segments" do
    @magnitude = 9
    segments = Minotaur::Scalar.new(@magnitude).split!(2,4)
    #segments.count.should == 2
    segments.should == [4,5]
  end
end