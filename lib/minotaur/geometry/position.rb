module Minotaur
  module Geometry
    class Position < Struct.new(:x, :y)
      #include DirectionHelpers

      def ==(other)
        self.x == other.x && self.y == other.y
      end

      def +(other)
        Position.new(self.x + other.x, self.y + other.y)
      end

      def translate(direction,n=1)
        Position.new(self.x + n*DX[direction], self.y + n*DY[direction])
      end

      def adjacent
        all_directions.map { |direction| translate(direction) }
      end

      def to_s; "(#{self.x}, #{self.y})" end

    end
  end
end
