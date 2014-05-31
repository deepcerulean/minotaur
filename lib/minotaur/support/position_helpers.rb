module Minotaur
  module Support
    module PositionHelpers
      include Geometry

      #
      #def position(x_coordinate, y_coordinate)
      #  Position.new(x_coordinate, y_coordinate)
      #end

      def origin
        Position.new(0,0)
      end


      # TODO really belongs to a path, i think?
      #      doesn't seem to be used except by prettifiers (!)
      def adjacent_in_path?(start,destination,path)
        adjacent = start.adjacent.include?(destination)
        return adjacent unless path
        if path.index(start) && path.index(destination) && (path.index(start) - path.index(destination)).abs == 1
          adjacent
        else
          false
        end
      end

      def distance_between(start,destination)
	dx = start.x - destination.x
	dy = start.y - destination.y
	Math.sqrt(dx.abs**2 + dy.abs**2) #(start.x - destination.x).abs^2 + abs(start.y - destination.y).abs^2)
      end
    end
  end
end
