module Minotaur
  module Geometry
    #
    #  a grid 'instruments' a space with a logical matrix
    #  we use this matrix to record 'passability'.
    #
    class Grid < Space
      include Minotaur::Helpers::PositionHelpers
      attr_accessor :rows

      def initialize(opts={})
        self.location = opts.delete(:location) { origin }
        self.width    = opts.delete(:width)  { 1 }
        self.height   = opts.delete(:height) { 1 }
        self.rows = Array.new(self.height) { Array.new(self.width,0) }

        super(location:location,width:width, height: height)
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
        width.times do |x|
          height.times do |y|
            yield Position.new(x,y)
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