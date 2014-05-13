require 'spec_helper'
require 'pry'

describe Minotaur::World do
  its('cities.count')   { should eql(Minotaur::World::DEFAULT_CITY_COUNT) }
  its('dungeons.count') { should eql(Minotaur::World::DEFAULT_DUNGEON_COUNT) }
  its(:population)      { should eql(subject.cities.map(&:population).reduce(&:+)) }

  it 'should increase city population' do
    old_population = subject.population
    subject.step!
    subject.population.should be > old_population
  end
end
