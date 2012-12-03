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

      DEFAULT_ROOM_COUNT = 10

      attr_accessor :room_count, :rooms
      attr_accessor :stairs
      attr_accessor :doors

      def extrude!(opts={})
        self.room_count = opts.delete(:room_count) { DEFAULT_ROOM_COUNT }

        self.rooms = opts.delete(:rooms) do
          Array.new(self.room_count) { generate(:room) }
        end

        #puts '--- placin'
        self.rooms.each do |room|
          attempt_to_place room
        end

        #puts '--- carvin'
        interval = DEFAULT_PASSAGEWAY_UNIT
        Grid.each_position(width-2,height-1) do |pos|
          pos = pos + Position.new(1,1)
          if pos.x % interval == 0 && pos.y % interval == 0
            carve_passageways!(opts.merge!(start: pos, depth: 0))
          end
        end

        #puts '--- emplacin'
        all_corridor_positions.each do |pos|
          nonempty_adjacent = pos.adjacent.select { |p| nonempty?(p) }

          if nonempty_adjacent.count == 1 && coinflip?
            stairs << Stairwell.new(location: pos)
            #puts "--- placing stairwell at #{pos}"
          elsif nonempty_adjacent.count == 2
            first, second = nonempty_adjacent[0], nonempty_adjacent[1]
            if direction_to(pos,first) == direction_opposite(direction_to(pos,second))
               #direction_opposite(pos.direction)
              if (any_room_contains?(first) || any_room_contains?(second)) && !door?(first) && !door?(second)
                doors << Door.new(location: pos)
                #puts "--- placing door at #{pos}"
              end
            end
          end
        end
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

      MAX_DEPTH = 32
      DEFAULT_PASSAGEWAY_UNIT = 4
      def carve_passageways!(opts={})
        depth       = opts.delete(:depth) { 0 }
        start       = opts.delete(:start)
        unit        = opts.delete(:unit)  { DEFAULT_PASSAGEWAY_UNIT }

        return if depth > MAX_DEPTH || !contains?(start)

        all_directions.shuffle.each do |direction|

          position = start.translate(direction,unit)
          next if  on_edge?(start)

          if contains?(position)
            empty_region = empty_surrounding?(position)
            if empty_region || within_any_room_and_not_perimeter?(position)
              (0...unit).each do |n|
                alpha = start.translate(direction,n)
                beta  = start.translate(direction,n+1)
                if contains?(alpha) && contains?(beta)
                  build_passage!(alpha,beta)
                  alpha.adjacent.each do |next_alpha|
                    build_passage!(alpha,next_alpha) if !empty?(next_alpha)
                  end
                end
              end
            end

            if empty_region || empty_surrounding_count(position) > 6
              carve_passageways!(opts.merge!(:start => position, :depth => depth + 1))
            end
          end
        end
        #end
      end

      private

      MAX_ATTEMPTS = 1000
      def attempt_to_place(room,opts={})
        attempts = 0
        proposed_location = nil
        while attempts <= MAX_ATTEMPTS
          attempts = attempts + 1
          proposed_x = (1..(self.width-room.width-1)).to_a.sample
          proposed_y = (1..(self.height-room.height-1)).to_a.sample
          proposed_location = Position.new( proposed_x, proposed_y  )
          break unless placement_conflict?(room, proposed_location)
        end

        if attempts < MAX_ATTEMPTS
          room.location = proposed_location
          room.carve!(self)
        end
      end

      def placement_conflict?(room, proposed_location)
        Grid.each_position(room.width, room.height) do |position|
          return true unless empty_surrounding?(position + proposed_location)
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