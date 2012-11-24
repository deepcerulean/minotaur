#require 'spec_helper'
#
#describe "scalar helpers" do
#  context "can split an uneven magnitude into subdivisions" do
#    let(:magnitude) { 9 }
#    subject do
#      split!(magnitude, :count => 2, :minimum => 4)
#    end
#    it { should eql([4,5]) }
#  end
#
#
#
#  context "can determine and identify overlapping ranges" do
#    let(:first_range) { 0..5 }
#
#    subject do
#      range_overlap(first_range,second_range)
#    end
#    describe "when simply overlapping" do
#      context "and second range is after first range" do
#        let(:second_range) { 3..6 }
#        it { should eql(3..5) }
#      end
#      context "and second range is after first range" do
#        let(:second_range) { -3..3 }
#        it { should eql(0..3) }
#      end
#    end
#    describe "when one includes the other" do
#      context "and second range includes the first range" do
#        let(:second_range) { 1..4 }
#        it { should eql(second_range) }
#      end
#    end
#  end
#end