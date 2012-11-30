module Minotaur
  module Extruders
    module AssemblingRoomExtruder
      include Geometry
      include Support::ThemeHelpers
      include Support::FateHelpers

      DEFAULT_ROOM_COUNT = 10

      attr_accessor :room_count, :rooms

      def extrude!(opts={})
        self.room_count = opts.delete(:room_count) { DEFAULT_ROOM_COUNT }
        self.rooms = opts.delete(:rooms) do
          Array.new(self.room_count) { generate(:room) }
        end
        #super(opts)

        puts '--- placin'
        place_rooms!
        puts '--- carvin'
        carve_passageways!(opts)
      end

      def place_rooms!
        #puts "=== place #{self.room_count} rooms"
        self.rooms.each do |room|
          #puts "--- attempting to place room #{room}"
          attempt_to_place room
        end
      end

      #DEFAULT_REGION_SIZE = 3
      DEFAULT_ROUNDS = 10
      MAX_DEPTH = 100
      def carve_passageways!(opts={})

        start       = opts.delete(:start) { all_positions.sample }
        depth       = opts.delete(:depth) { 0 }

        return if depth > MAX_DEPTH

        # 'empty' here basically means 'unexplored'
        each_direction_with_an_empty_region_from(start,3) do |direction|
          (0..3).each do |n|
            alpha = start.translate(direction,n)
            beta  = start.translate(direction,n+1)
            if contains?(alpha) && contains?(beta)
              build_passage!(alpha,beta)

              alpha.adjacent.each do |p|
                if contains?(p) && !empty?(p)
                  build_passage!(alpha,p)
                end
              end

              beta.adjacent.each do |p|
                if contains?(p) && !empty?(p)
                  build_passage!(beta,p)
                end
              end
            end
            opts[:start] = start.translate(direction,3)
            opts[:depth] = depth + 1
            carve_passageways!(opts)
          end
        end
      end

      private
      MAX_ATTEMPTS = 100
      DEFAULT_MARGIN = 0
      def attempt_to_place(room,opts={})
        attempts = 0
        proposed_location = nil
        while attempts <= MAX_ATTEMPTS
          attempts = attempts + 1
          proposed_x = (0..(self.width-room.width)).to_a.sample
          proposed_y = (0..(self.height-room.height)).to_a.sample
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
          position = position + proposed_location
          unless empty_surrounding?(position)
            return true
          end
        end
        false
      end
    end
  end
end