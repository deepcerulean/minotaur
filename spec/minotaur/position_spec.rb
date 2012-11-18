require "rspec"
require 'minotaur'

describe Minotaur::Position do
  let(:x) { 4 }
  let(:y) { 5 }

  subject do
    Minotaur::Position.new(x,y)
  end

  its(:x) { should eql(x) }
  its(:y) { should eql(y) }

  context "should translate itself" do
    let(:x) { 0 }
    let(:y) { 0 }

    Minotaur::Directions.all.each do |direction|
      let(:translated_subject) do
        subject.translate(direction)
      end

      let(:expected_position) do
        Minotaur::Position.new(
          Minotaur::DX[direction],
          Minotaur::DY[direction]
        )
      end
      it "should translate itself #{Minotaur::Direction.humanize(direction)} to (#{Minotaur::DX[direction]},#{Minotaur::DY[direction]})" do
        translated_subject.should == expected_position
      end
    end

    it "should be translated north twice to (0,-2)" do
      subject.translate(Minotaur::NORTH, 2).to_s.should == "(0, -2)"
    end
  end
  # TODO more real tests
  pending "some more real tests"
end