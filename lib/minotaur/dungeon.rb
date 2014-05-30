module Minotaur
  class Dungeon < Entity
    include Support::ThemeHelpers
    DEFAULT_WIDTH  = 40
    DEFAULT_HEIGHT = 40 
    DEFAULT_DEPTH  = 15
    DEFAULT_ROOM_COUNT = 20

    attr_accessor :levels, :height, :width, :depth, :entities

    def initialize(opts={})
      self.width  = opts.delete(:width)  { DEFAULT_WIDTH  }
      self.height = opts.delete(:height) { DEFAULT_HEIGHT }
      self.depth  = opts.delete(:depth)  { DEFAULT_DEPTH  }

      @intended_room_count = opts.delete(:room_count) { DEFAULT_ROOM_COUNT } 
      super(opts)

      generate!
    end

    def generate!
      extruder = Extruders::AssemblingRoomExtruder
      pathfinder = Pathfinders::DijkstrasPathfinder

      base_opts = { width: self.width, height: self.height, extruder: extruder, pathfinder: pathfinder }
      first_level = Minotaur::Labyrinth.new(base_opts.dup) 
      first_level.extrude!({down_stairs_count: 1, up_stairs_count: 0, room_count: @intended_room_count})

      self.levels = [ first_level ]

      (1...self.depth).each do |current_depth|
	level = Minotaur::Labyrinth.new(base_opts.dup)
	level.extrude!({stair_count: 0, room_count: @intended_room_count}) 
	@levels << level
      end

      @levels.each_cons(2) do |upper, lower|
	# puts "=== Considering levels #{@levels.index(upper)} and #{@levels.index(lower)}"
#	binding.pry
	possible_positions = Stairwell.good_locations(upper) & Stairwell.good_locations(lower) 
	target = possible_positions.sample
	# puts "--- Placing stairwells at #{target}"
	upper.emplace_stairwell!(target)
	lower.emplace_stairwell!(target, Stairwell::UP)
      end

      @entities = []
      self.levels.each_with_index do |level, i|
	@entities[i] = []
	level.rooms.each { |room| @entities[i] = @entities[i] + room.entities }
      end
    end
    def to_s
      "dungeon of depth #{depth}"
    end

    def pc_name
      generate(:player_name)
    end
  end
end
