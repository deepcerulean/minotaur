require 'spec_helper'

describe Scalar do
  #
  it "can split an uneven magnitude into segments" do
    @magnitude = 9
    segments   = Scalar.new(@magnitude).split!(:count => 2, :minimum => 4)
    #segments.count.should == 2
    segments.should == [4,5]
  end
end