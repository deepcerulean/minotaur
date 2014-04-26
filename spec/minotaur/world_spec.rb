require 'spec_helper'
require 'pry'

describe Minotaur::World do
  its('cities.count')   { should eql(Minotaur::World::DEFAULT_CITY_COUNT) }
  its('dungeons.count') { should eql(Minotaur::World::DEFAULT_DUNGEON_COUNT) }
end
