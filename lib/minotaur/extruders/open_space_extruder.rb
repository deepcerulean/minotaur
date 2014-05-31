module Minotaur
  module Extruders
    module OpenSpaceExtruder
      def extrude!
	room = Room.new(width: width, height: height)
	room.carve!(self)
      end
    end
  end
end
