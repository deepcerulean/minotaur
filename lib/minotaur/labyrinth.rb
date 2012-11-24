module Minotaur
  DEFAULT_EXTRUDER     = Extruders::RecursiveBacktrackingExtruder
  DEFAULT_PATHFINDER   = Pathfinders::RecursiveBacktrackingPathfinder
  DEFAULT_PRETTIFIER   = Prettifier::SimplePrettifier

  #
  #   TODO proper dungeon generator
  #   (basepoint for weaving component behavior)
  #
  #   for now just internalize all the various components
  #   (extruders, pathfinders, etc)
  #
  class Labyrinth #< Grid
    attr_accessor :size
    attr_accessor :height, :width
    attr_accessor :rows

    attr_accessor :extruder_module, :pathfinder_module, :prettifier_module

    def initialize(opts={})
      self.size   = opts.delete(:size)
      self.width  = self.size || opts.delete(:width)  { DEFAULT_SIZE }
      self.height = self.size || opts.delete(:height) { DEFAULT_SIZE }
      self.extruder_module   = opts.delete(:extruder)   || DEFAULT_EXTRUDER
      self.pathfinder_module = opts.delete(:pathfinder) || DEFAULT_PATHFINDER
      self.prettifier_module = opts.delete(:prettifier) || DEFAULT_PRETTIFIER
      self.width  = width
      self.height = height
      self.rows   = Array.new(self.height) { Array.new(self.width,0) }

      extend extruder_module
      extend pathfinder_module
      extend prettifier_module
    end


    # core grid functionality (was in a parent class once...)

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
      Labyrinth.each_position(self.width,self.height) { |pos| all << pos }
      all
    end

    def open?(position)
      all_directions? { |direction| passable?(position,direction) }
    end

  end
end