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

    def mark!(position, direction)
      self.rows[position.y][position.x] |= direction
    end

    def build_passage!(position,next_position)
      direction = Direction.from(position, next_position)
      mark!(position,direction)
      other_direction = Direction.opposite(direction)
      mark!(next_position, other_direction)
    end

    def passable?(origin,direction) #destination)
      #raise "Only adjacent cells can be passable" unless origin.adjacent.include?(destination)
      #direction = Direction.from(origin, destination)
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



    def to_s(path=[],path_indicator='*',path_start_indicator='a',path_end_indicator='b')
      output = " " + "_" * (self.width * 2 - 1) << "\n"
      self.height.times do |y|
        output << "|"
        self.width.times do |x|
          pos = Position.new(x,y)
          if path.include?(pos)
            output << case pos
              when path.first then path_start_indicator
              when path.last  then path_end_indicator
              else path_indicator
            end
            #if path.first == pos
            #  output << path_start_indicator
            #elsif path.last == pos
            #  output << path_end_indicator
            #else
            #  output << path_indicator
            #end
          else
            output << (passable?(pos,SOUTH) ? " " : "_") #(self.rows[y][x] & SOUTH != 0) ? " " : "_")
          end

          if self.rows[y][x] & EAST != 0
            output << (((at(pos) | at(pos.translate(EAST))) & SOUTH != 0) ? " " : "_")
                      #(((self.rows[y][x] | self.rows[y][x+1]) & SOUTH != 0) ? " " : "_")
          else
            output << "|"
          end
        end
        output << "\n"
      end
      output
    end


    #
    # helpers (may belong somewhere else?)
    #


    def self.each_position(width,height)
      width.times do |x|
        height.times do |y|
          yield Position.new(x,y)
        end
      end
    end
  end
end