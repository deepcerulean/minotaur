require "rspec"
require 'minotaur'

include Minotaur

describe Position do
  let(:x) { 4 }
  let(:y) { 5 }

  subject do
    Position.new(x,y)
  end

  its(:x) { should eql(x) }
  its(:y) { should eql(y) }

  context "should translate itself" do
    let(:x) { 0 }
    let(:y) { 0 }

    all_directions.each do |direction|
      let(:translated_subject) do
        subject.translate(direction)
      end

      let(:expected_position) do
        Position.new(DX[direction], DY[direction])
      end
      it "should translate itself #{humanize_direction(direction)} to (#{DX[direction]},#{DY[direction]})" do
        translated_subject.should == expected_position
      end
    end

    it "should be translated north twice to (0,-2)" do
      subject.translate(NORTH, 2).to_s.should == "(0, -2)"
    end
  end
end