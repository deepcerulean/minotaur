module Minotaur
  class Dungeon < Entity
    include Support::ThemeHelpers
    DEFAULT_WIDTH  = 20
    DEFAULT_HEIGHT = 20 
    DEFAULT_DEPTH  = 5
    DEFAULT_ROOM_COUNT = 10

    attr_accessor :levels, :height, :width, :depth, :entities

    def initialize(opts={})
      self.width  = opts.delete(:width)  { DEFAULT_WIDTH  }
      self.height = opts.delete(:height) { DEFAULT_HEIGHT }
      self.depth  = opts.delete(:depth)  { DEFAULT_DEPTH  }

      @intended_room_count = opts.delete(:room_count) { DEFAULT_ROOM_COUNT } 
      super(opts)

      puts "generating #{self.width}x#{self.height} dungeon..."
      generate!
    end

    def generate!
      extruder = Extruders::AssemblingRoomExtruder
      pathfinder = Pathfinders::DijkstrasPathfinder

      base_opts = { width: self.width, height: self.height, extruder: extruder, pathfinder: pathfinder }
      first_level = Minotaur::Labyrinth.new(base_opts.dup) 
      first_level.extrude!({down_stairs_count: 1, up_stairs_count: 0, room_count: @intended_room_count})

      self.levels = [ first_level ]

      threads = []
      (1..self.depth-1).each do |current_depth|
	threads << Thread.new do
	  level = Minotaur::Labyrinth.new(base_opts.dup)
	  level.extrude!({stair_count: 0, room_count: @intended_room_count}) 
	  @levels << level
	end
      end
      threads.each { |th| th.join }

      @levels.each_cons(2) do |upper, lower|
	possible_positions = Stairwell.good_locations(upper) & Stairwell.good_locations(lower) 
	target = possible_positions.sample

	upper.emplace_stairwell!(target)
	lower.emplace_stairwell!(target, Stairwell::UP)
      end


      @entities = []
      self.levels.each_with_index do |level, i|
	@entities[i] = []
	level.rooms.each do |room|
	  occupied_locations = []
	  room.features.treasure.gold.each do |gp|
	    location = (room.all_positions - occupied_locations).sample
	    @entities[i] << OpenStruct.new(type: :gold, amount: gp.amount, location: location)
	    occupied_locations << location
	  end

	  room.features.treasure.potions.each do |potion|
	    location = (room.all_positions - occupied_locations).sample
	    @entities[i] << OpenStruct.new(type: :potion, amount: potion.amount, location: location, color: potion.color) # amount: gp.amount, location: location)
	    occupied_locations << location
	  end

	  room.features.treasure.scrolls.each do |scroll|
	    location = (room.all_positions - occupied_locations).sample
	    @entities[i] << OpenStruct.new(type: :scroll, amount: scroll.amount, location: location, title: scroll.title)
	    occupied_locations << location
	  end
	end
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
