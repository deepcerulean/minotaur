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

      def extrude!(opts={})
        self.room_count = opts.delete(:room_count) { DEFAULT_ROOM_COUNT }

        self.rooms = opts.delete(:rooms) do
          Array.new(self.room_count) { generate(:room) }
        end

        puts '--- placin'
        self.rooms.each do |room|
          attempt_to_place room
        end

        puts '--- carvin'
        Grid.each_position(width-2,height-1) do |pos|
          pos = pos + Position.new(1,1)
          if pos.x % 2 == 0 && pos.y % 2 == 0
            carve_passageways!(opts.merge!(start: pos, depth: 0)) #if coinflip?(4)
          end
        end
      end

      #DEFAULT_REGION_SIZE = 3
      MAX_DEPTH = 256
      DEFAULT_PASSAGEWAY_UNIT = 3
      def carve_passageways!(opts={})
        depth       = opts.delete(:depth) { 0 }
        start       = opts.delete(:start)
        unit        = opts.delete(:unit)  { DEFAULT_PASSAGEWAY_UNIT }

        return if depth > MAX_DEPTH || !contains?(start)

        #(0..DEFAULT_PASSAGEWAY_UNIT).each do |unit|
        all_directions.shuffle.each do |direction|
          position = start.translate(direction,unit)
          next if  on_grid_edge?(start)
          if contains?(position)
            empty_region = empty_surrounding_count(position) > 6 #_count(position) == 0
            if empty_region # || (unit == DEFAULT_PASSAGEWAY_UNIT && within_any_room?(position))
              (0..unit).each do |n|
                alpha = start.translate(direction,n)
                beta  = start.translate(direction,n+1)
                if contains?(alpha) && contains?(beta) && !on_grid_edge?(alpha) && !on_grid_edge?(beta)
                  build_passage!(alpha,beta)
                  alpha.adjacent.each do |next_alpha|
                    build_passage!(alpha,next_alpha) if !empty?(next_alpha) && !on_grid_edge?(next_alpha) #|| !within_any_room?(next_alpha) #unless within_any_room?(next_alpha) #unless empty?(next_alpha) #if empty_surrounding_count(next_alpha) > 3
                  end
                  beta.adjacent.each do |next_beta|
                    build_passage!(beta,next_beta) if !empty?(next_beta) && !on_grid_edge?(next_beta) #|| !within_any_room?(next_alpha) #unless within_any_room?(next_alpha) #unless empty?(next_alpha) #if empty_surrounding_count(next_alpha) > 3
                  end
                  #beta.adjacent.each do |next_beta|
                  #  build_passage!(beta,next_beta) unless empty?(next_beta) #if empty_surrounding_count(next_alpha) > 3
                  #end
                end
              end
            end
            if empty_region
              carve_passageways!(opts.merge!(:start => position, :depth => depth + 1))
            end
          end
        end
        #end
      end

      private
      MAX_ATTEMPTS = 1000
      DEFAULT_MARGIN = 0
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


      def within_any_room?(position)
        rooms.each do |room|
          return true if room.contains?(position)
        end
        false
      end

      def on_grid_edge?(position)
        return true if position.x == 0 || position.y == 0 || position.x == width-1 || position.y == height-1
      end
    end
  end
end