module Minotaur
  module Geometry
    #
    #   track a position in 2-d space
    #   with some extra helpers for grids
    #
    class Position < Struct.new(:x, :y)
      include Helpers::DirectionHelpers


      def ==(other)
        self.x == other.x && self.y == other.y
      end

      def +(other)
        Position.new(self.x + other.x, self.y + other.y)
      end

      def translate(direction,count=1)
        Position.new(self.x + count*DX[direction], self.y + count*DY[direction])
      end

      def adjacent
        all_directions.map { |direction| translate(direction) }
      end

      def to_s
        "(#{self.x}, #{self.y})"
      end

    end
  end
end
