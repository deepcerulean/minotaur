module Minotaur
  class Dungeon
    DEFAULT_WIDTH  = 20
    DEFAULT_HEIGHT = 20
    DEFAULT_DEPTH  = 30 

    attr_accessor :levels, :height, :width, :depth

    def initialize(opts={})
      self.width  = opts.delete(:width)  { DEFAULT_WIDTH  }
      self.height = opts.delete(:height) { DEFAULT_HEIGHT }
      self.depth  = opts.delete(:depth)  { DEFAULT_DEPTH  }
      
      extruder = Extruders::AssemblingRoomExtruder

      base_opts = { width: self.width, height: self.height, extruder: extruder }
      first_level = Minotaur::Labyrinth.new(base_opts.dup) 
      first_level.extrude!({down_stairs_count: 1, up_stairs_count: 0})

      self.levels = [ first_level ]
      (1..self.depth).each do |depth|
	last_level = @levels[depth-1]
	level = Minotaur::Labyrinth.new(base_opts.dup)
	last_stair_location = last_level.stairs.detect { |s| s.down? }.location
	level.extrude!({up_stairs_location: last_stair_location}) #rescue binding.pry
	@levels << level
      end
    end
  end
end
