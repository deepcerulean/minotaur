module Minotaur
  module Extruders
    #
    #  generate rooms, place them, connect them
    #
    #  some inspiration goes to donjon for the basic approach
    #   (http://donjon.bin.sh/dungeon/about/)
    #   
    #  not anymore really kind of doing this on my own!
    #
    #  way too slow, i would think (have made some minor improvements). but maybe we can pregen etc.?
    #
    #  would be nice to add cellular automata for caves... :)
    #
    module AssemblingRoomExtruder
      include Geometry
      include Support::ThemeHelpers
      include Support::FateHelpers
      include Support::DirectionHelpers

      DEFAULT_ROOM_COUNT = 20
      MAX_DEPTH = 100
      MAX_ATTEMPTS = 30

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

        self.room_count = opts.delete(:room_count) { DEFAULT_ROOM_COUNT }
        self.rooms = opts.delete(:rooms) do
          Array.new(self.room_count) { generate(:room) }
        end

	# attempt to place first room next to stairs, or in the middle of the map
      
	place_first_room!
	recursively_place_adjacent_rooms(self.placed_rooms.first)
	attempts = 0

	until unplaced_rooms.count == 0 || attempts > MAX_ATTEMPTS
	  print "."
	  attempts = attempts + 1
	  recursively_place_adjacent_rooms(self.placed_rooms.sample)
	end

	self.rooms = placed_rooms
	carve_passageways!
	#print '.'
	# emplace_stairs!	if self.stair_count > 0
	print '!'
      end

      def place_first_room!
	first_room = self.rooms.sample
	if self.up_stairs_location
	  stairs << Stairwell.new(location: self.up_stairs_location, access: Stairwell::UP)

	  chosen_direction = nil
	  located_first_room = false
	  until located_first_room
	    first_room = self.rooms.sample
	    chosen_direction = attempt_to_place_adjacent_to_position(first_room, self.up_stairs_location)
	    located_first_room = true unless chosen_direction == false
	  end
	  
	  direction = (chosen_direction)
	  stair_position = self.up_stairs_location
	  room_position = self.up_stairs_location.translate(direction)
	    binding.pry unless first_room.contains?(room_position)

	  build_passage!(stair_position, room_position) 
	else
	  place_centrally first_room
	end
      end

      def emplace_stairwell!(position, access=Stairwell::DOWN)
	binding.pry if position.nil? || position.x.nil?
	puts "=== EMPLACING STAIRWELL"
        stairs << Stairwell.new(location: position, access: access)

	# room = rooms.detect { |r| r.contains?(position) || r.outer_perimeter?(position) }
	#binding.pry unless room
	if room = rooms.detect { |r| r.outer_perimeter?(position) }
	  direction = room.direction_for_outer_perimeter_position(position)
	  next_position = position.translate(direction_opposite(direction))
	  #binding.pry unless room.contains?(next_position)
	  build_passage!(next_position, position)
	end
      end

      # def emplace_stairs!
      #   until stairs.count >= self.stair_count
      #     self.rooms.shuffle.each do |room|
      #       perimeter = room.outer_perimeter - all_corridor_positions
      #       position = perimeter.select { |p| contains?(p) }.sample

      #       # try not to place adjacent to two rooms at once...
      #       next if empty_surrounding_count(position) < 5

      #       access = Stairwell::DOWN
      #       access = Stairwell::UP if stairs.count { |s| s.up? } < self.up_stairs_count

      #       stairs << Stairwell.new(location: position, access: access)

      #       direction = room.direction_for_outer_perimeter_position(position)
      #       next_position = position.translate(direction_opposite(direction))
      #       
      #       # binding.pry
      #       binding.pry unless room.contains?(next_position)
      #       build_passage!(next_position, position)
      #       
      #       break if self.stairs.count >= self.stair_count 
      #     end
      #   end
      # end

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
	  room.adjacent_room_directions[dir].include?(other_room) 
	end
      end

      def adjacent_room_adjoining_edge(room, other_room)
	direction = direction_between_rooms(room, other_room)
	case direction
	when NORTH, SOUTH then
	  range_overlap(room.horizontal_range, other_room.horizontal_range).to_a 
	when EAST, WEST then
	  range_overlap(room.vertical_range, other_room.vertical_range).to_a
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
	  x = other_room.x + other_room.width
	  y = adjacent_room_adjoining_edge(room, other_room).sample
	when WEST then
	  x = room.x + room.width
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

	build_passage!(first,second) 
	build_passage!(second,third)
	doors << Door.new(location: second)

	room.connected_rooms << other_room
	other_room.connected_rooms << room
      end

      def place_room(room, position)
	room.location = position
	room.carve!(self)
	room.placed = true
      end

      def place_centrally(room)
	center_with_offset = Position.new(self.width/2 - room.width/2, self.height/2 - room.height/2)
	place_room room, center_with_offset
      end

      def attempt_to_place_adjacent_to_position(room, position, direction=nil)
	success, proposed_direction, proposed_location = place_adjacent_to_position(room, position, direction)

	if success
	  place_room(room,proposed_location)
	  binding.pry unless room.outer_perimeter.include?(position)
	  return proposed_direction
	end

	false
      end

      def place_adjacent_to_position(room, position, direction=nil)
	proposed_location = nil
	proposed_direction = nil
	conflict = true
	
	room.each_adjacent_space(position, {direction: direction, offset: 0}) do |target_position, dir|
	  proposed_location  = target_position
	  proposed_direction = dir
	  conflict           = placement_conflict?(room, proposed_location)

	  break unless conflict
	end
	
	return false if conflict
	[true, proposed_direction, proposed_location]
      end

      def recursively_place_adjacent_rooms(source,depth=0)
	raise "first room not placed" unless source.placed
	return if depth <= -MAX_DEPTH
	unplaced_rooms.shuffle.take(2).each do |target|
	  next if target.placed
	  if attempt_to_place_adjacently(target, source)
	    recursively_place_adjacent_rooms(target,depth-1)
	  end
	end
      end

      def attempt_to_place_adjacently(room, other_room, direction=nil)
	proposed_location = nil
	success, proposed_direction, proposed_location = place_adjacent_to_room(room,other_room,direction)

	if success
	  room.adjacent_rooms << other_room
	  room.adjacent_room_directions[proposed_direction] << other_room

	  other_room.adjacent_rooms << room
	  other_room.adjacent_room_directions[direction_opposite(proposed_direction)] << room

	  place_room(room, proposed_location)
	end

	success
      end

      def can_contain_adjacent_position?(room,other_room,direction)
	case direction
	when NORTH then (return false) if other_room.y - room.height <= 1
	when SOUTH then (return false) if other_room.y + room.height >= self.height - 1
	when EAST then  (return false) if other_room.x - room.width <= 1
	when WEST then (return false)  if other_room.x + room.width >= self.width - 1
	end

	true
      end
      
      # TODO smarten up
      def place_adjacent_to_room(room, other_room, direction=nil) 
	proposed_location = nil
	proposed_direction = nil
	conflict = true

	room.each_adjacent_space(other_room, {direction: direction}) do |position, dir|
	  proposed_location = position
	  proposed_direction = dir
	  
	  next unless can_contain_adjacent_position?(room, other_room, proposed_direction)
	  conflict = placement_conflict?(room, proposed_location)
	  break unless conflict
	end

	return false if conflict
	[true, proposed_direction, proposed_location]
      end

      ## helpers

      def placement_conflict?(room, proposed_location)
	room.location = proposed_location
	room.each_position do |p|
	  if !empty_surrounding?(p)
	    return true
	  end
	end

	false
      end

      def any_room_contains?(position)
	rooms.any? { |room| room.contains?(position) }
      end

      def within_any_room_and_not_perimeter?(position)
	rooms.any? { |room| room.contains?(position) && !room.perimeter?(position) } 
      end

      def all_corridor_positions
	all_nonempty_positions.reject { |p| any_room_contains?(p) }
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

      def stairs_up?(pos)
	stairs.detect { |s| s.location == pos }.up?
      end
    end
  end
end
