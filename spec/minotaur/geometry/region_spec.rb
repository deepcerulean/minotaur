require 'spec_helper'
require 'pry'

describe Minotaur::Region do
  subject { Minotaur::Region.new(x: 1, y: 1, width: 3, height: 3) }
  it 'should map perimeter' do
    subject.perimeter.each do |point|
      subject.perimeter?(point).should be_true
    end
  end
end

