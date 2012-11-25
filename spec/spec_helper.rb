require "rspec"
require "minotaur"

require "support/shared_examples_for_pathfinders"

include Minotaur

include Geometry
include Directions

include Helpers
include PositionHelpers
include DirectionHelpers
include RangeHelpers
include FateHelpers

include Extruders
include Pathfinders
include Prettifier