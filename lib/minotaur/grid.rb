module Minotaur
  MIN_SIZE = 10
  DEFAULT_SIZE = 25

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

    def self.each_position(width,height)
      width.times do |x|
        height.times do |y|
          yield Position.new(x,y)
        end
      end
    end

    #def adjacent_from(origin)
    #  origin.adjacent.select { |position| contains? position }
    #end

    def empty_adjacent_from(origin)
      origin.adjacent.select do |position|
        contains?(position) && empty?(position)
      end
    end

    def mark!(position, direction)

      puts "=============="
      puts "--- Marking #{position} as passable to the #{Direction.humanize(direction)}"
      puts "--- before: "
      puts to_s
      self.rows[position.y][position.x] |= direction
      puts "--- after: "
      puts to_s

    end

    def build_passage!(position,next_position)
      #p self
      puts
      puts
      puts "============="
      puts "--- Carving passage between #{position} and #{next_position}"
      direction = Direction.from(position, next_position)
      puts "--- Marking #{position} with passage in direction #{Direction.humanize direction}"
      mark!(position,direction)

      other_direction = Direction.opposite(direction)
      puts "--- Marking #{next_position} with a passage in the other direction #{Direction.humanize other_direction}"
      mark!(next_position, other_direction)
    end

    def to_s
      output = " " + "_" * (self.width * 2 - 1) << "\n"
      self.height.times do |y|
        output << "|"
        self.width.times do |x|
          output << ((self.rows[y][x] & SOUTH != 0) ? " " : "_")
          if self.rows[y][x] & EAST != 0
            output << (((self.rows[y][x] | self.rows[y][x+1]) & SOUTH != 0) ? " " : "_")
          else
            output << "|"
          end
        end
        output << "\n"
      end
      output
    end
  end
end