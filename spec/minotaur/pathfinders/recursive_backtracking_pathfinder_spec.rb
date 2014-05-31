require "spec_helper"
require "support/shared_examples_for_pathfinders"

include Minotaur::Pathfinders

# SOOO SLOWWWW
describe RecursiveBacktrackingPathfinder do
  it_should_behave_like "a pathfinder"
end
