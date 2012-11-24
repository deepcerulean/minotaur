module Minotaur
  module Geometry
    class Grid < Space

      attr_accessor :size
      attr_accessor :height, :width
      attr_accessor :rows

      def initialize(opts={})
        self.location = opts.delete(:location) { origin }

        self.size   = opts.delete(:size)
        self.width  = self.size || opts.delete(:width)  { DEFAULT_SIZE }
        self.height = self.size || opts.delete(:height) { DEFAULT_SIZE }
        self.width  = width
        self.height = height
        self.rows   = Array.new(self.height) { Array.new(self.width,0) }

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
        self.rows[position.y][position.x] |= value
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

      # TODO really belongs to a path, i think?
      def adjacent?(start,destination,path=[])
        adjacent = start.adjacent.include?(destination)
        return adjacent unless path
        if path.index(start) && path.index(destination) && (path.index(start) - path.index(destination)).abs == 1
          adjacent
        else
          false
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
        all_directions? { |direction| passable?(position,direction) }
      end
    end
  end
end