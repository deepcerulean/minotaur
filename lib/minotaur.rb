# require deps here?
require "rubygems"
require "bundler"
Bundler.setup(:default)
require "dice"

require "ostruct"

require "minotaur/version"

require "minotaur/support/fate_helpers"
require "minotaur/support/range_helpers"


require "minotaur/geometry/directions"
require "minotaur/support/direction_helpers"

require "minotaur/geometry/position"
require "minotaur/support/position_helpers"

require "minotaur/geometry/size"
require "minotaur/support/size_helpers"

require "minotaur/geometry/region"

require "minotaur/geometry/space"
require "minotaur/geometry/grid"
require "minotaur/geometry/splitter"
require "minotaur/geometry/mutator"
require "minotaur/geometry/subdivider"

require "minotaur/prettifiers/simple_prettifier"
require "minotaur/prettifiers/compact_prettifier"

require "minotaur/extruders/recursive_backtracking_extruder"
require "minotaur/extruders/subdividing_room_extruder"
require "minotaur/extruders/assembling_room_extruder"

require "minotaur/pathfinders/recursive_backtracking_pathfinder"


#require "minotaur/features/feature"
#require "minotaur/features/atmosphere"
#require "minotaur/features/creature"
#require "minotaur/features/treasure"
#require "minotaur/features/item"
#require "minotaur/features/trap"
#require "minotaur/features/aura"
#require "minotaur/features/alignment"
#require "minotaur/features/name"
#require "minotaur/features/room_type"

require "minotaur/theme"
require "minotaur/support/theme_helpers"
require "minotaur/themes/roguelike"


require "minotaur/door"
require "minotaur/room"
require "minotaur/labyrinth"

require "minotaur/explorer/explorer"

#
#
#
module Minotaur
  DEFAULT_THEME = Minotaur::Themes::Roguelike
end

