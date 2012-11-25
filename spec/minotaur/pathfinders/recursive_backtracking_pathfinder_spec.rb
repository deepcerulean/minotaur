require 'spec_helper'

include Minotaur::Pathfinders

describe RecursiveBacktrackingPathfinder do
  it_should_behave_like "a pathfinder"
end