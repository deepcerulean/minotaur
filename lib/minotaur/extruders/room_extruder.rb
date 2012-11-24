module Minotaur
  module Extruders
    module RoomExtruder
      attr_accessor :rooms, :doors
      attr_accessor :start, :min_edge_length, :variance

      def extrude!(opts={})
        self.start            = opts.delete(:start)            { origin }
        self.min_edge_length  = opts.delete(:min_edge_length)  { 5 }
        self.variance         = opts.delete(:variance)         { 0 }

        carve_rooms!
        carve_doorways!
      end

      def subdivider
        @subdivider = Subdivider.new(min_edge_length: min_edge_length, variance: variance)
      end

      def carve_rooms!
        self.rooms = []
        root = Room.new(location: start, width: width, height: height)
        subdivider.subdivide(root).each do |room|
          self.rooms << room
          carve_room!(room)
        end
      end


      def carve_room!(room)
        Grid.each_position(room.width,room.height) do |position|
          build_passage!(position,position.translate(WEST))  unless position.x <= (room.location).x
          build_passage!(position,position.translate(NORTH)) unless position.y <= (room.location).y
          build_passage!(position,position.translate(EAST))  unless position.x >= (room.location).x + room.width  - 1
          build_passage!(position,position.translate(SOUTH)) unless position.y >= (room.location).y + room.height - 1
        end
      end

      def each_adjoining_room_pair
        @already_yielded = []
        @rooms.each do |room|
          @rooms.each do |other_room|
            unless (room == other_room)
              if room.adjoining?(other_room)
                pair = [room,other_room]
                yield pair unless @already_yielded.include?(pair)
                @already_yielded << [room,other_room]
                @already_yielded << [other_room,room]
              end
            end
          end
        end
      end

      def carve_doorways!
        puts "--- Carving doorways between #{@rooms.size} rooms."
        @doors = []
        each_adjoining_room_pair do |room,other_room|
          carve_doorway!(room,other_room)
        end
      end

      def carve_doorway!(room,other_room)
        shared_edge = room.adjoining_edge(other_room)
        puts "--- Got adjoining edge between #{room} and #{other_room}: "
        p shared_edge
        a,b = shared_edge.sort_by { rand }.first
        start,finish = Position.new(a[0],a[1]), Position.new(b[0],b[1])
        build_passage!(start,finish)
      end
    end
  end
end