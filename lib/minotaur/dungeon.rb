module Minotaur
  class Dungeon
    include Support::ThemeHelpers
    DEFAULT_WIDTH  = 20
    DEFAULT_HEIGHT = 20 
    DEFAULT_DEPTH  = 5
    DEFAULT_ROOM_COUNT = 10

    attr_accessor :levels, :height, :width, :depth, :entities

    def initialize(opts={})
      # print 'generating dungeon...'
      self.width  = opts.delete(:width)  { DEFAULT_WIDTH  }
      self.height = opts.delete(:height) { DEFAULT_HEIGHT }
      self.depth  = opts.delete(:depth)  { DEFAULT_DEPTH  }

      @intended_room_count = opts.delete(:room_count) { DEFAULT_ROOM_COUNT } 
      
      extruder = Extruders::AssemblingRoomExtruder
      pathfinder = Pathfinders::DijkstrasPathfinder

      base_opts = { width: self.width, height: self.height, extruder: extruder, pathfinder: pathfinder }
      first_level = Minotaur::Labyrinth.new(base_opts.dup) 
      first_level.extrude!({down_stairs_count: 1, up_stairs_count: 0, room_count: @intended_room_count})

      puts
      print 'generating levels...'
      self.levels = [ first_level ]
      (1..self.depth-1).each do |current_depth|
	print '.'
	last_level = @levels[current_depth-1]
	level = Minotaur::Labyrinth.new(base_opts.dup)
	last_stair_location = last_level.stairs.detect { |s| s.down? }.location

	down_stairs_count = if current_depth == self.depth - 1
			      0
			    else
			      1
			    end

	level.extrude!({up_stairs_location: last_stair_location, room_count: @intended_room_count, down_stairs_count: down_stairs_count}) #rescue binding.pry
	@levels << level
      end

      puts
      print 'placing entities (just gold for now)...'
      @entities = []
      self.levels.each_with_index do |level, i|
	print '.'
	@entities[i] = []
	level.rooms.each do |room|
	  # place gp (todo simplify -- could just be objects after all...)
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

      puts "done!"
    end

    def to_s
      "dungeon of depth #{depth}"
    end

    def pc_name
      generate(:player_name)
    end
  end
end
