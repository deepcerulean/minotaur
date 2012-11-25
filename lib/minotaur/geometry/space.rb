module Minotaur
  module Geometry
    #
    #  base superclass for logical 'regions' or 'planes' like grids and labyrinths
    #
    class Space
      attr_accessor :location, :width, :height

      def initialize(opts={})
        self.location = opts.delete(:location) { origin }
        self.width    = opts.delete(:width)    { 1 }
        self.height   = opts.delete(:height)   { 1 }
      end

      def to_s
        "#{width}x#{height} space at #{location}"
      end

      def x
        location.x
      end

      def y
        location.y
      end

      def area
        width * height
      end

      def adjoining_direction(other,inverse=false)
        #puts "--- Attempting to determine adjoining direction between #{self} and #{other}"
        if other.x == self.x+self.width #+1
          if range_overlap?( (y..y+height-1), (other.y..other.y+other.height-1) )
            #puts "--- got EAST"
            return EAST
          end
        elsif other.y == self.y+self.height #+1
          if range_overlap?( (x..x+width-1), (other.x..other.x+other.width-1) )
            #puts "--- got SOUTH"
            return SOUTH
          end
        end

        # we're exhausted if we were called by ourselves
        return nil if inverse

        direction_opposite(other.adjoining_direction(self,true))
      end


      def adjoining?(other_room)
        !adjoining_direction(other_room).nil?
      end

      def adjoining_edge(other,inverse=false)
        direction = adjoining_direction(other)
        if direction == SOUTH
          range = range_overlap(self.x...self.x+width-1, other.x...other.x+other.width-1)
          range.map { |next_x| [[next_x,other.y-1],[next_x,other.y]] }
        elsif direction == EAST
          range = range_overlap(self.y...self.y+height-1, other.y...other.y+other.height-1)
          range.map { |next_y| [[other.x-1,next_y],[other.x,next_y]] }
        else
          inverse ? nil : other.adjoining_edge(self,true)
        end
      end

      def subdivide(opts={})
        # don't like reusing opts here, but...
        Subdivider.new(opts).subdivide(self,opts)
      end
    end
  end
end