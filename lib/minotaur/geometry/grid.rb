module Minotaur
  module Geometry
    #
    #  a grid 'instruments' a space with a logical matrix
    #  we use this matrix to record 'passability'.
    #
    #  (see also Geometry::Direction.)
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

      def empty?(position)
        at(position).zero?
      end

      def nonempty?(position)
        !empty?(position)
      end



      def empty_surrounding_count(position)
        position.surrounding.count do |other|
          contains?(other) && empty?(other) #: true
        end
      end

      def empty_surrounding?(position)
        empty_surrounding_count(position) == position.surrounding.count
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
        space.each_position do |position|
          build_passage!(position,position.translate(WEST))  unless position.x <= space.location.x
          build_passage!(position,position.translate(NORTH)) unless position.y <= space.location.y
          build_passage!(position,position.translate(EAST))  unless position.x >= space.location.x + space.width - 1
          build_passage!(position,position.translate(SOUTH)) unless position.y >= space.location.y + space.height - 1
        end
      end

      def empty_adjacent_to(start)
        start.adjacent.shuffle.select do |position|
          contains?(position) && empty?(position)
        end
      end

      def empty_surrounding_and_adjacent_to(start)
        start.adjacent.shuffle.select do |position|
          contains?(position) && empty_surrounding?(position)
        end
      end

      def each_empty_adjacent_to(start)
        empty_adjacent_to(start).select do |position|
          yield position if contains?(position) && empty?(position)
        end
      end

      def each_direction_with_an_empty_region_from(start,distance=3)
        all_directions.map do |direction|
          position = start.translate(direction,distance)
          yield direction if empty_surrounding?(position)
        end
      end


      def accessible_adjacent_to(start)
	start.adjacent.select do |adjacent|
	  contains?(adjacent) && accessible?(adjacent)
	end
      end

      def accessible_surrounding(start)
	start.surrounding.select { |s| contains?(s) && accessible?(s) }
      end

      def passable_adjacent_to(start)
        start.adjacent.select do |adjacent|
          contains?(adjacent) && passable?(start,direction_from(start,adjacent))
        end
      end

      def each_passable_adjacent_to(start)
        passable_adjacent_to(start).each do |adjacent|
          yield adjacent # if contains?(adjacent) && passable?(start,direction_from(start,adjacent))
        end
      end

      def all_empty_positions
        all_positions.select { |position| empty?(position) }
      end

      def all_nonempty_positions
        all_positions.select { |position| nonempty?(position) }
      end

      def open?(position)
        all_directions.all? do |direction|
          passable?(position,direction)
        end
      end

      def accessible?(position)
	all_directions.any? do |direction|
	  passable?(position,direction)
	end
      end

      def all_open_positions
        all_positions.select { |position| open?(position) }
      end

      def on_edge?(position)
        return true if position.x == 0 || position.y == 0 || position.x == width-1 || position.y == height-1
      end
    end
  end
end
