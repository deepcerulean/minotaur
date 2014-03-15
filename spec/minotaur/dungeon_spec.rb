require 'spec_helper'
require 'pry'
describe Minotaur::Dungeon do
  it 'should have one stairwell on the first floor' do
    subject.levels.first.stairs.count.should eql(1)
  end

  it 'should have interconnected levels' do
    first_floor  = subject.levels[0]
    second_floor = subject.levels[1]

    first_floor_stairwell = first_floor.stairs.detect { |s| s.down? }
    second_floor_stairwell = second_floor.stairs.detect { |s| s.up? }

    # at least one of the second floor stairs should match
    first_floor_stairwell.location.should eql(second_floor_stairwell.location)
  end
end
