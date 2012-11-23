module Minotaur
  module Extruders
    module RoomExtruder
      include PositionHelpers
      attr_accessor :rooms

      def extrude!(opts={}) #origin=Position.origin)
        start            = opts.delete(:start) { origin }
        min_edge_length  = opts.delete(:min_edge_length) { 5 }
        variance         = opts.delete(:variance) { min_edge_length/2 }

        carve_rooms!(start, min_edge_length,variance)
        carve_doorways!
      end

      def carve_rooms!(start, min_edge_length, variance=0)
        @rooms = []
        root = Room.new(start, self.width, self.height)
        puts "--- About to call split! on #{root} with min edge length #{min_edge_length}"
        root.split!({min_edge_length: min_edge_length, variance: variance}).each do |room|
          @rooms << room
          carve_room!(room)
        end
      end

      def carve_doorways!
        @rooms.each do |room|
          @rooms.each do |other_room|
            unless room == other_room             #if these are not the same room
                                                  #  if room and other_room are adjacent
              if room.adjacent?(other_room)
                #  flip a coin
                if rand > 0.3
                  #    heads, then connect them!
                  carve_doorway!(room,other_room)
                end
              end
            end
          end
        end
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
        puts "--- would be trying to carve a doorway between #{room} and #{other_room}"
      end
    end
  end
end