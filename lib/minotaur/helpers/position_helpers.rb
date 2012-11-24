module Minotaur
  module Helpers
    module PositionHelpers
      def origin
        Position.new(0,0)
      end

      def pt(x,y)
        Position.new(x,y)
      end
    end
  end
end