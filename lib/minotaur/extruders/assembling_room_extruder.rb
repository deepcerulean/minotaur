module Minotaur
  module Extruders
    #
    #  generate rooms, place them, connect them
    #
    #  some inspiration goes to donjon for the basic approach
    #   (http://donjon.bin.sh/dungeon/about/)
    #
    module AssemblingRoomExtruder
      include Geometry
      include Support::ThemeHelpers
      include Support::FateHelpers
      include Support::DirectionHelpers

      DEFAULT_ROOM_COUNT = 20
      MAX_DEPTH = 10

      attr_accessor :room_count, :rooms
      attr_accessor :stairs
      attr_accessor :doors
      attr_accessor :passageways
      attr_accessor :stair_count, :down_stairs_count, :up_stairs_count, :up_stairs_location

      def extrude!(opts={})
	self.down_stairs_count  = opts.delete(:down_stairs_count) { 1 }
	self.up_stairs_count    = opts.delete(:up_stairs_count) { 1 }
	self.stair_count   	= opts.delete(:stair_count) { self.down_stairs_count + self.up_stairs_count } 
	self.up_stairs_location = opts.delete(:up_stairs_location) { nil }

        puts "=== extruding!"
        self.room_count = opts.delete(:room_count) { DEFAULT_ROOM_COUNT }
        self.rooms = opts.delete(:rooms) do
          Array.new(self.room_count) { generate(:room) }
        end

	# attempt to place first room next to stairs, or in the middle of the map
	place_first_room!
	recursively_place_adjacent_rooms(self.placed_rooms.first)

	# puts "=== placed #{placed_rooms.count} rooms"
	self.rooms = placed_rooms

        # puts '--- carving walkways...'
	carve_passageways!
	
        # puts '--- emplacing stairs...'
	emplace_stairs!	
	
	# puts "--- emplacing doors..."
	emplace_doors!

        # puts "--done!"
        puts self.to_s
      end

      def place_first_room!
	first_room = self.rooms.sample
	if self.up_stairs_location
	  stairs << Stairwell.new(location: self.up_stairs_location, access: Stairwell::UP)

	  # have to select an appropriately-sized room here (could potentially choose one too big to work, especially on small maps i would think...)
	  chosen_direction = nil
	  located_first_room = false
	  until located_first_room
	    first_room = self.rooms.sample
	    print '.'
	    chosen_direction = attempt_to_place_adjacent_to_position(first_room, self.up_stairs_location)
	    located_first_room = true unless chosen_direction == false
	  end
	  
	  direction = (chosen_direction)
	  # puts "--- attempting to place first room next to stairs at #{up_stairs_location} in direction #{humanize_direction direction}"
	  stair_position = self.up_stairs_location
	  room_position = self.up_stairs_location.translate(direction)
	  binding.pry unless first_room.contains?(room_position)

	  build_passage!(stair_position, room_position) #self.up_stairs_location, self.up_stairs_location.translate(direction))
	  # binding.pry
	  # binding.pry unless first_room.placed
	else
	  place_centrally first_room
	end
      end

      def emplace_stairs!
	until stairs.count >= self.stair_count
	  self.rooms.shuffle.each do |room|
	    # print "--- attempting to place stairs in #{room.to_s}"
	    perimeter = room.outer_perimeter - all_corridor_positions
	    position = perimeter.select { |p| contains?(p) }.sample

	    # puts "--- using position #{position}"
	    access = Stairwell::DOWN
	    access = Stairwell::UP if stairs.count { |s| s.up? } < self.up_stairs_count

	    # puts "--- stair direction is #{access == Stairwell::DOWN ? 'down' : 'up'}"
	    stairs << Stairwell.new(location: position, access: access)

	    # carve opening back into room...
	    direction = room.direction_for_outer_perimeter_position(position)
	    # binding.pry
	    # puts "--- carving opening into room from #{position} in direction #{humanize_direction direction}"
	    next_position = position.translate(direction_opposite(direction))
	    # puts "--- target position #{next_position}"
	    build_passage!(next_position, position)
	    
	    # puts "--- checking if #{stairs.count} > #{stair_count}"
	    break if self.stairs.count >= self.stair_count 
	  end
	end
      end

      def emplace_doors!
        all_corridor_positions.each do |pos|
          nonempty_adjacent = pos.adjacent.select { |p| contains?(p) && nonempty?(p) }
          if nonempty_adjacent.count > 1 # == 2
            first, second = nonempty_adjacent[0], nonempty_adjacent[1]
            if direction_to(pos,first) == direction_opposite(direction_to(pos,second))
              if (any_room_contains?(first) || any_room_contains?(second)) && !door?(first) && !door?(second)
                doors << Door.new(location: pos)
              end
            end
          end
        end
      end

      ###

      def room_adjacency_matrix
	self.rooms.map do |room|
	  self.rooms.map do |other_room|
	    room.adjacent_rooms.include?(other_room) ? 1 : 0
	  end
	end
      end

      def placed_rooms
	self.rooms.select { |room| room.placed? }
      end

      def unplaced_rooms
	self.rooms.reject { |room| room.placed? } 
      end

      def placed_rooms_with_open_adjacencies
	placed_rooms.select { |room| room.adjacent_rooms.count < 2 }
      end

      def doors
        @doors ||= []
      end

      def door?(pos)
        doors.any? { |door| door.location == pos }
      end

      def stairs
        @stairs ||= []
      end

      def stairs?(pos)
        stairs.any? { |stairwell| stairwell.location == pos }
      end

      def carve_passageways!
	self.rooms.each do |room|
	  room.adjacent_rooms.each do |other_room|
	    next if room.connected?(other_room)
	    carve_passageway!(room,other_room) 
	  end
	end
      end

      def direction_between_rooms(room, other_room)
	all_directions.detect do |dir|
	  room.adjacent_room_directions[dir].include?(other_room) rescue binding.pry
        end
      end

      def adjacent_room_adjoining_edge(room, other_room)
        direction = direction_between_rooms(room, other_room)
	case direction
	when NORTH, SOUTH then
	  range_overlap(room.x...room.x+room.width-1, other_room.x...other_room.x+other_room.width-1).to_a
	when EAST, WEST then
	  range_overlap(room.y...room.y+room.height-1, other_room.y...other_room.y+other_room.height-1).to_a
	end
      end

      def carve_passageway!(room,other_room)
        direction = direction_between_rooms(room, other_room)
	case direction
	when NORTH then 
          x = adjacent_room_adjoining_edge(room, other_room).sample 
	  y = room.y + room.height
	when SOUTH then
          x = adjacent_room_adjoining_edge(room, other_room).sample 
	  y = other_room.y + other_room.height
	when EAST then
	  x = room.x + room.width
          y = adjacent_room_adjoining_edge(room, other_room).sample
	when WEST then
	  x = other_room.x + other_room.width
          y = adjacent_room_adjoining_edge(room, other_room).sample
	end

	first, second, third = nil, nil, nil
	case direction
	when NORTH, SOUTH
	  first = Position.new(x,y-1)
	  second = Position.new(x,y)
	  third = Position.new(x,y+1)
	when EAST, WEST
	  first = Position.new(x-1,y)
	  second = Position.new(x,y)
	  third = Position.new(x+1,y)
	end

	build_passage!(first,second) rescue binding.pry
	build_passage!(second,third)

	room.connected_rooms << other_room
	other_room.connected_rooms << room
      rescue
	binding.pry
      end

      def place_randomly(room,opts={})
	room.location = random_position(room.width, room.height)
	room.placed = true
	room.carve!(self)
      end

      def random_position(target_width, target_height)
        proposed_x = (2..(self.width-target_width-2)).to_a.sample
        proposed_y = (2..(self.height-target_height-2)).to_a.sample
        Position.new( proposed_x, proposed_y  )
      end

      def place_centrally(room)
	room.location = Position.new(self.width/2 - room.width/2, self.height/2 - room.height/2)
	room.placed = true
	room.carve!(self)
      end

      def attempt_to_place_adjacent_to_position(room, position)
	# puts "--- attempting to place #{room.to_s} adjacent to #{position.to_s}"
	shuffled_directions.each do |direction|
	  proposed_location = place_adjacent_to_position(room, position, direction)
	  if proposed_location 
	    room.location = proposed_location
	    room.placed = true
	    room.carve!(self)
	    return direction
	  end
	end

	false
      end

      # almost straight-copy of logic for placing rooms adjacently
      def place_adjacent_to_position(room, position, direction=shuffled_directions.sample)
        # proposed_direction = direction
	proposed_x, proposed_y = nil, nil
	proposed_location = nil
	range_to_iterate = case direction
			   when NORTH, SOUTH then (((-room.width)+1)..0) #(room.width-1))
			   when EAST, WEST   then (((-room.height)+1)..0) #(room.height-1))
			   end

	range_to_iterate.each do |i|
	  case direction
	  when NORTH then 
	    proposed_y = position.y - room.height 
	    proposed_x = position.x + i 
	  when SOUTH then
	    proposed_y = position.y + 1
	    proposed_x = position.x + i
	  when EAST then
	    proposed_x = position.x + 1
	    proposed_y = position.y + i
	  when WEST then
	    proposed_x = position.x - room.width
	    proposed_y = position.y + i
	  end

	  proposed_location = Position.new(proposed_x, proposed_y)

	  # next unless contains?(proposed_location)
	  break unless placement_conflict?(room, proposed_location)
	end

	# binding.pry if placement_conflict?(room, proposed_location)

	return false if placement_conflict?(room, proposed_location)

	# puts "--- proposing location for new room at #{proposed_location.to_s} (adjacent #{humanize_direction(direction)} to #{position.to_s})"
	proposed_location
      end

      def recursively_place_adjacent_rooms(source,depth=0)
	raise "first room not placed" unless source.placed
	return if depth <= -MAX_DEPTH
	unplaced_rooms.each do |target|
	  next if target.placed
	  shuffled_directions.each do |direction|
	    if attempt_to_place_adjacently(target, source, direction)
	      recursively_place_adjacent_rooms(target,depth-1)
	      break
	    end
	  end
	end
      end

      def attempt_to_place_adjacently(room, other_room, direction=shuffled_directions.sample) # opts={})
	raise "room already placed" if room.placed
	proposed_location = nil
	  proposed_direction, proposed_location = random_adjacent_position(room,other_room,direction)
	  unless placement_conflict?(room,proposed_location)
	    room.location = proposed_location
	    room.adjacent_rooms << other_room
	    room.adjacent_room_directions[(proposed_direction)] << other_room
	    other_room.adjacent_rooms << room
	    other_room.adjacent_room_directions[direction_opposite(proposed_direction)] << room
	    room.placed = true
	    room.carve!(self)
	    return true
	  end
	false
      end

      def random_adjacent_position(room,other_room,direction=shuffled_directions.first)
        proposed_direction = direction
	proposed_x, proposed_y = nil, nil
	proposed_location = nil
	range_to_iterate = case proposed_direction
			   when NORTH, SOUTH then (((-room.width)+2)..(other_room.width-2))
			   when EAST, WEST then (((-room.height)+2)..(other_room.height-2))
			   end

	range_to_iterate.each do |i|
	  case proposed_direction
	  when NORTH then 
	    proposed_y = other_room.y - room.height - 1 # + 1
	    proposed_x = other_room.x + i
	  when SOUTH then
	    proposed_y = other_room.y + other_room.height + 1 # - 1 
	    proposed_x = other_room.x + i
	  when EAST then
	    proposed_x = other_room.x - room.width - 1  # + 1
	    proposed_y = other_room.y + i
	  when WEST then
	    proposed_x = other_room.x + other_room.width + 1  # - 1
	    proposed_y = other_room.y + i
	  else
	    raise "unknown direction #{proposed_direction}"
	  end
	  proposed_location = Position.new(proposed_x, proposed_y)
	  break unless placement_conflict?(room, proposed_location)
	end

	[proposed_direction, Position.new( proposed_x, proposed_y)]
      end

      def placement_conflict?(room, proposed_location)
	binding.pry if proposed_location.x.nil? || proposed_location.y.nil?
	Grid.each_position(room.width, room.height) do |position|
	  translated = position + proposed_location
	  return true unless contains?(translated) && empty_surrounding?(translated)
	end
	false
      end

      def any_room_contains?(position)
	rooms.each do |room|
	  return true if room.contains?(position) #&& !room.perimeter?(position)
	end
	false
      end


      def within_any_room_and_not_perimeter?(position)
	rooms.each do |room|
	  return true if room.contains?(position) && !room.perimeter?(position)
	end
	false
      end

      def all_corridor_positions
	all_nonempty_positions.reject { |p| any_room_contains?(p) }
      end
    end
  end
end
