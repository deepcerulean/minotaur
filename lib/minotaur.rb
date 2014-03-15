# require deps here?
require "rubygems"
require "bundler"
Bundler.setup(:default)

# external deps
require "dice"
#require "chingu"

# ruby std lib stuff
require "ostruct"

# internal load order
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
require "minotaur/serializers/array_serializer"

require "minotaur/theme"
require "minotaur/support/theme_helpers"


require "minotaur/extruders/recursive_backtracking_extruder"
require "minotaur/extruders/subdividing_room_extruder"
require "minotaur/extruders/assembling_room_extruder"

require "minotaur/pathfinders/recursive_backtracking_pathfinder"

require "minotaur/themes/roguelike"

require "minotaur/door"
require "minotaur/stairwell"
require "minotaur/room"
require "minotaur/labyrinth"
require "minotaur/dungeon"

#require "minotaur/explorer/player"
#require "minotaur/explorer/window"


module Minotaur
  DEFAULT_THEME = Minotaur::Themes::Roguelike

  def self.root
    File.join(File.dirname(__FILE__), '../')
  end
end

