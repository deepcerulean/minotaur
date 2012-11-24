module Minotaur
  module Extruders
    module RoomExtruder
      include PositionHelpers
      attr_accessor :rooms, :doors

      def extrude!(opts={}) #origin=Position.origin)
        start            = opts.delete(:start) { origin }
        min_edge_length  = opts.delete(:min_edge_length) { 5 }
        variance         = opts.delete(:variance) { 0 }

        carve_rooms!(start, min_edge_length,variance)
        carve_doorways!
      end

      def carve_rooms!(start=origin, min_edge_length=5, variance=0)
        @rooms = []
        root = Room.new(start, width, height)
        root.split!({min_edge_length: min_edge_length, variance: variance}).each do |room|
          @rooms << room
          carve_room!(room)
        end
      end

      def carve_doorways!
        puts "=== Attempting to carve doorways...!"
        @doors = []

        @rooms.each do |room|
          @rooms.each do |other_room|
            unless (room == other_room) || @doors.include?([room,other_room]) || @doors.include?([other_room,room])
              puts "--- considering rooms #{room} and #{other_room} for adjacency..."
              if room.adjacent?(other_room)
                @doors << [room,other_room]
                carve_doorway!(room,other_room)
              else
                puts "--- not adjacent..."
              end
            end
          end
        end
        puts "--- carved #{@doors.count} doors"
        p @doors
        puts self
      end



      def carve_room!(room)
        Labyrinth.each_position(room.width,room.height) do |position|
          open!(room.location + position,room)
        end
      end

      def open!(position,room)
        build_passage!(position,position.translate(WEST))  unless position.x <= (room.location).x
        build_passage!(position,position.translate(NORTH)) unless position.y <= (room.location).y
        build_passage!(position,position.translate(EAST))  unless position.x >= (room.location).x + room.width  - 1
        build_passage!(position,position.translate(SOUTH)) unless position.y >= (room.location).y + room.height - 1
      end

      def carve_doorway!(room,other_room)
        puts "=== carving doorway between #{room} and #{other_room}"
        shared_edge = room.shared_edge(other_room)
        #puts self
        puts "--- shared edge: "
        p shared_edge
        a,b = shared_edge.sort_by { rand }.first
        start,finish = Position.new(a[0],a[1]), Position.new(b[0],b[1])
        build_passage!(start,finish)
        #build_passage!(finish,start)
        #puts self
      end
    end
  end
end