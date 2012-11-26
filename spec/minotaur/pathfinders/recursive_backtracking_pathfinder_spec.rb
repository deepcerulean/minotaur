require "spec_helper"
require "support/shared_examples_for_pathfinders"

include Minotaur::Pathfinders

describe RecursiveBacktrackingPathfinder do
  it_should_behave_like "a pathfinder"
end