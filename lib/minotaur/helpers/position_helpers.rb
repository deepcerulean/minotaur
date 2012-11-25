module Minotaur
  module Helpers
    module PositionHelpers
      def origin
        Position.new(0,0)
      end

      def pt(x,y)
        Position.new(x,y)
      end


      # TODO really belongs to a path, i think?
      #      doesn't seem to be used except by prettifier (!)
      #def adjacent_in_path?(start,destination,path)
      #  adjacent = start.adjacent.include?(destination)
      #  return adjacent unless path
      #  if path.index(start) && path.index(destination) && (path.index(start) - path.index(destination)).abs == 1
      #    adjacent
      #  else
      #    false
      #  end
      #end
    end
  end
end