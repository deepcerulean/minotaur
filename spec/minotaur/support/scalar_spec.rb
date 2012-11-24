require 'spec_helper'

describe "scalar helpers" do
  context "can split an uneven magnitude into segments" do
    let(:magnitude) { 9 }
    subject do
      split!(magnitude, :count => 2, :minimum => 4)
    end
    it { should eql([4,5]) }
  end
end