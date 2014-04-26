module Minotaur
  class Dungeon < Entity
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
      super(opts)

      generate!
    end

    # TODO consider whether it makes sense for generation to be 'lazy'...
    # 	   eventually maybe we don't generate very 'deeply' parts of the world
    # 	   that no character has visited
    def generate!
      extruder = Extruders::AssemblingRoomExtruder
      pathfinder = Pathfinders::DijkstrasPathfinder

      base_opts = { width: self.width, height: self.height, extruder: extruder, pathfinder: pathfinder }
      first_level = Minotaur::Labyrinth.new(base_opts.dup) 
      first_level.extrude!({down_stairs_count: 1, up_stairs_count: 0, room_count: @intended_room_count})

      puts
      print 'generating levels...'
      self.levels = [ first_level ]
      # TODO could do this in parallel if we moved the stairway-threading out of the room placement... ruby should let us do a simple lock/latch on whether that last level's downstairs has been placed yet; although the performance there would not really be much improved since it's only placed after everything is done! so yeah we have to move it out...
      # not sure that really saves us much on mri, but still
      # will try on jruby...
      # i'd be curious if we can run rubinius yet
      threads = []
      puts "generating levels!"
      (1..self.depth-1).each do |current_depth|
	threads << Thread.new do
	  print '.'
	  level = Minotaur::Labyrinth.new(base_opts.dup)
	  # last_stair_location = last_level.stairs.detect { |s| s.down? }.location

	  level.extrude!({stair_count: 0, room_count: @intended_room_count}) #up_stairs_location: last_stair_location, room_count: @intended_room_count, down_stairs_count: down_stairs_count}) #, up_stairs_count: 0}) #rescue binding.pry
	  @levels << level
	end
      end
      threads.each { |th| th.join }

      # so it's a little harder now, we have to find pairs of good stairwell locations on two levels!
      #
      # WEAVING STAIRS TOGETHER!!!
      puts "weaving stairs"
      @levels.each_cons(2) do |upper, lower|
	puts "--- stairs..."
	possible_positions = Stairwell.good_locations(upper) & Stairwell.good_locations(lower) 
	target = possible_positions.sample

	binding.pry unless target
	upper.emplace_stairwell!(target)
	lower.emplace_stairwell!(target, Stairwell::UP)
      end

      # (1..self.depth-1).each do |current_depth|
      #   print '.'
      #   last_level = @levels[current_depth-1]
      #   # find a down stars for last level and an up stairs for this one
      # end

      puts
      print 'placing entities (just gold/potions/scrolls for now)...'
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

    # def extrude_levels!; end

    def to_s
      "dungeon of depth #{depth}"
    end

    def pc_name
      generate(:player_name)
    end
  end
end
