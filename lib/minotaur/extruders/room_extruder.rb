module Minotaur
  module Extruders
    module RoomExtruder
      def extrude!(origin=Position.origin)
        root = Room.new(origin, self.width, self.height)
        root.split!.each { |room| carve_room!(room) }
      end


      def carve_room!(room)
        Grid.each_position(room.width,room.height) do |position|
          open!(room.location + position,room)
        end
      end


      def open!(position,room)
        build_passage!(position,position.translate(WEST))  unless position.x <= (room.location).x
        build_passage!(position,position.translate(NORTH)) unless position.y <= (room.location).y
        build_passage!(position,position.translate(EAST))  unless position.x >= (room.location).x + room.width  - 1#- 3
        build_passage!(position,position.translate(SOUTH)) unless position.y >= (room.location).y + room.height - 1 #- 3
      end
    end
  end
end