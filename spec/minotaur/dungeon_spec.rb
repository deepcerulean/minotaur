require 'spec_helper'
require 'pry'
describe Minotaur::Dungeon do
  its('levels.count') { should eql(Minotaur::Dungeon::DEFAULT_DEPTH) }

  it 'should have one stairwell on the first floor' do
    subject.levels.first.stairs.count.should eql(1)
  end

  it 'should have one stairwell on the last floor' do
    subject.levels.last.stairs.count.should eql(1)
  end

  it 'should have interconnected levels' do
    subject.levels.each_cons(2) do |this_level, next_level|
      puts this_level.to_s
      down_stairs = this_level.stairs.detect(&:down?)
      up_stairs = next_level.stairs.detect(&:up?)
      down_stairs.location.should eql(up_stairs.location)
    end
  end

  it 'should find pathways' do
    subject.levels.each do |level|
      next if level == subject.levels.first || level == subject.levels.last
      up = level.stairs.detect(&:up?)
      down = level.stairs.detect(&:down?)
      # puts level.to_s
      solution = level.path(up.location, down.location)
      solution.should_not be_nil
      solution.first.should eql(up.location)
      solution.last.should eql(down.location)
      # puts solution #levelshortest_path(up.location, down.location)
    end
    # second_floor = subject.levels[1]
    # up = second_floor.stairs.detect(&:up?)
    # down = second_floor.stairs.detect(&:down?)
    # # puts second_floor.to_s
    # puts second_floor.shortest_path(up.location, down.location)
  end

  it 'should place entities' do
    first_gold_piece = subject.entities[0].first
    first_gold_piece.type.should eql(:gold)
    first_gold_piece.amount.should be >= 1 
  end
end
