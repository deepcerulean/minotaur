module Minotaur
  module Geometry
    #
    #  base superclass for logical 'regions' or 'planes' like grids and labyrinths
    #
    class Space < Region
      include Directions
      include Support::RangeHelpers
      include Support::DirectionHelpers
      include Support::SizeHelpers

      #attr_accessor :location, :width, :height

      def initialize(opts={})
        #self.location = opts.delete(:location) #{ origin }
        #if opts.include?(:width) && opts.include?(:height)
        #  self.size     = Size.new(width: opts.delete(:width), height: opts.delete(:height))
        #else
        #  self.size     = opts.delete(:size)     { unit }
        #  self.size     = Size.new(width: size, height: size) if self.size.is_a? Fixnum
        #end
        super(opts)
      end

      def carve!(grid); grid.build_space!(self) end

      def adjoining_direction(other,inverse=false)
        if adjoining_east?(other)
          EAST
        elsif adjoining_south?(other)
          SOUTH
        elsif inverse
          nil
        else
          direction_opposite(other.adjoining_direction(self,true))
        end
      end

      def adjoining?(other_room)
        !adjoining_direction(other_room).nil?
      end

      def adjoining_edge(other,inverse=false)
        direction = adjoining_direction(other)
        if direction == SOUTH
          adjoining_southern_edge(other)
        elsif direction == EAST
          adjoining_eastern_edge(other)
        else
          inverse ? nil : other.adjoining_edge(self,true)
        end
      end

      def subdivide(opts={})
        Subdivider.new(opts).subdivide(self,opts)
      end

      # protected

      def adjoining_east?(other)
        other.x == self.x+self.width && range_overlap?( (y..y+height-1), (other.y..other.y+other.height-1) )
      end

      def adjoining_south?(other)
        other.y == self.y+self.height && range_overlap?( (x..x+width-1), (other.x..other.x+other.width-1) )
      end

      def adjoining_southern_edge(other)
        range = range_overlap(self.x...self.x+width-1, other.x...other.x+other.width-1)
        range.map { |next_x| [[next_x,other.y-1],[next_x,other.y]] }
      end

      def adjoining_eastern_edge(other)
        range = range_overlap(self.y...self.y+height-1, other.y...other.y+other.height-1)
        range.map { |next_y| [[other.x-1,next_y],[other.x,next_y]] }
      end
      
    end
  end
end
