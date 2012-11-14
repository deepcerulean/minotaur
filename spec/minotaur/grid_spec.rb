require 'rspec'

require "minotaur"

describe Minotaur::Grid do
  let(:width)   { 123 }
  let(:height)  { 254 }

  subject do
    Minotaur::Grid.new(width, height)
  end

  its(:width)   { should eql(width) }
  its(:height)  { should eql(height) }

  pending "some real tests"

  pending "e.g., carves a passage"
end