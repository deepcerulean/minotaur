module Minotaur
  module Geometry
    #
    #   track a position in 2-d space
    #   with some extra helpers for grids
    #
    class Position < Struct.new(:x, :y)
      include Support::DirectionHelpers

      def ==(other)
        self.x == other.x && self.y == other.y
      end

      def +(other)
        Position.new(self.x + other.x, self.y + other.y)
      end

      def translate(direction,count=1)
        Position.new(self.x + count*DX[direction], self.y + count*DY[direction])
      end

      def adjacent #(n=1)
        all_directions.map { |direction| translate(direction) }
      end

      def diagonal_neighbors #(n=1)
        arr = []
        all_directions.map do |first_direction|
          all_directions.map do |second_direction|
            if first_direction != second_direction
              diagonal = translate(first_direction).translate(second_direction)
              arr << diagonal unless arr.include?(diagonal)
            end
          end
        end
        arr
      end

      def surrounding #(depth=n)
        adjacent + diagonal_neighbors
      end

      def to_s
        "(#{self.x}, #{self.y})"
      end

    end
  end
end
