module Minotaur
  class Position < Struct.new(:x, :y)
    #def <=>(other)
    #  self.x <=> other.x && self.y <=> other.y
    #end
    #include Comparable

    def ==(other)
      self.x == other.x && self.y == other.y
    end

    def translate(direction,n=1)
      Position.new(self.x + n*DX[direction], self.y + n*DY[direction])
    end

    def adjacent
      Directions.all.map { |direction| translate(direction) }
    end

    def to_s; "(#{self.x}, #{self.y})" end

    # some helpers
    def self.origin
      Position.new(0,0)
    end
  end
end
