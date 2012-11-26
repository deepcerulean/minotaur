module Minotaur
  module Geometry
    #
    #  a grid 'instruments' a space with a logical matrix
    #  we use this matrix to record 'passability'.
    #
    class Grid < Space
      include Support::PositionHelpers
      include Support::DirectionHelpers

      attr_accessor :rows

      def initialize(opts={})
        super(opts)
        self.rows = Array.new(self.height) { Array.new(self.width,0) }
      end

      def at(position)
        self.rows[position.y][position.x]
      end

      def contains?(position)
        position.x >= 0 && position.y >= 0 && position.x < self.width && position.y < self.height
      end

      def empty?(position)
        at(position).zero?
      end

      def inscribe!(position, value)
        raise "Cannot mark position #{position} (outside the grid)" unless contains?(position)
        rows[position.y][position.x] |= value
      end

      def build_passage!(position,next_position)
        direction = direction_from(position, next_position)
        inscribe!(position,direction)
        other_direction = direction_opposite(direction)
        inscribe!(next_position, other_direction)
      end

      def passable?(start,direction)
        (at(start) & direction) != 0
      end


      def build_space!(space)
        Grid.each_position(space.width,space.height) do |position|
          real_position = space.location + position
          build_passage!(real_position,real_position.translate(WEST))  unless real_position.x <= space.location.x
          build_passage!(real_position,real_position.translate(NORTH)) unless real_position.y <= space.location.y
          build_passage!(real_position,real_position.translate(EAST))  unless real_position.x >= space.location.x + space.width - 1
          build_passage!(real_position,real_position.translate(SOUTH)) unless real_position.y >= space.location.y + space.height - 1
        end
      end

      def empty_adjacent_to(start)
        start.adjacent.shuffle.select do |position|
          contains?(position) && empty?(position)
        end
      end

      def each_empty_adjacent_to(start)
        empty_adjacent_to(start).select do |position|
          yield position if contains?(position) && empty?(position)
        end
      end

      def passable_adjacent_to(start)
        start.adjacent.shuffle.select do |adjacent|
          contains?(adjacent) && passable?(start,direction_from(start,adjacent))
        end
      end

      def each_passable_adjacent_to(start)
        passable_adjacent_to(start).select do |adjacent|
          yield adjacent if contains?(adjacent) && passable?(start,direction_from(start,adjacent))
        end
      end

      def self.each_position(width,height)
        width.times do |x_coordinate|
          height.times do |y_coordinate|
            yield Position.new(x_coordinate, y_coordinate)
          end
        end
      end

      def all_positions
        all = []
        Grid.each_position(self.width,self.height) { |pos| all << pos }
        all
      end

      def open?(position)
        all_directions.all? do |direction|
          passable?(position,direction)
        end
      end
    end
  end
end