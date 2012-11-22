module Minotaur
  MIN_SIZE = 10
  DEFAULT_SIZE = 25

  #
  #   this class has a lot -- probably too many -- little miscellaneous helpers
  #   its' subclass labyrinth tries to solve this by weaving together complicated behavior into support
  #   and external classes (pathfinders, extruders.)
  #
  #
  #
  class Grid
    attr_accessor :height, :width
    attr_accessor :rows

    def initialize(width=DEFAULT_SIZE,height=DEFAULT_SIZE)
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
      direction = Direction.from(position, next_position)
      inscribe!(position,direction)
      other_direction = Direction.opposite(direction)
      inscribe!(next_position, other_direction)
    end

    def passable?(origin,direction)
      (at(origin) & direction) != 0
    end

    def empty_adjacent_to(origin)
      origin.adjacent.shuffle.select do |position|
        contains?(position) && empty?(position)
      end
    end

    def each_empty_adjacent_to(origin)
      empty_adjacent_to(origin).select do |position|
        yield position if contains?(position) && empty?(position)
      end
    end

    def passable_adjacent_to(origin)
      origin.adjacent.shuffle.select do |adjacent|
        contains?(adjacent) && passable?(origin,Direction.from(origin,adjacent))
      end
    end

    def each_passable_adjacent_to(origin)
      passable_adjacent_to(origin).select do |adjacent|
        yield adjacent if contains?(adjacent) && passable?(origin,Direction.from(origin,adjacent))
      end
    end

    def adjacent?(origin,destination,path=[])
      adjacent = origin.adjacent.include?(destination)
      return adjacent unless path
      if path.index(origin) && path.index(destination) && (path.index(origin) - path.index(destination)).abs == 1
        adjacent
      else
        false
      end
    end


    def prettifier
      @prettifier ||= Prettifier::CompactPrettifier.new
                      #Prettifier::SimplePrettifier.new
    end

    def to_s(path=[])
      prettifier.prettify(self,path)
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
      Directions.all? { |direction| passable?(position,direction) }
    end

  end
end