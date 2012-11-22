module Minotaur

  NORTH, SOUTH, EAST, WEST = 1, 2, 4, 8

  DX         = { EAST => 1, WEST => -1, NORTH =>  0, SOUTH => 0 }
  DY         = { EAST => 0, WEST =>  0, NORTH => -1, SOUTH => 1 }
  OPPOSITE   = { EAST => WEST, WEST =>  EAST, NORTH =>  SOUTH, SOUTH => NORTH }

  module Direction
    def self.humanize(direction)
      case direction
        when NORTH then "north"
        when SOUTH then "south"
        when EAST  then "east"
        when WEST  then "west"
      end
    end

    def self.opposite(direction)
      OPPOSITE[direction]
    end

    # assume no edge cases (could be made better)
    def self.from(a,b)
      raise "No distance between #{a} and #{b}" if a == b
      return WEST  if a.x > b.x
      return EAST  if a.x < b.x
      return NORTH if a.y > b.y
      return SOUTH if a.y < b.y
      raise "Can't determine direction between #{a} and #{b}!"
    end
  end

  module Directions
    def self.all;  [NORTH,SOUTH,EAST,WEST] end
    def self.all?;  all.all? end
    def self.shuffled; all.sort_by { rand } end
    def self.each; all.each end
  end
end