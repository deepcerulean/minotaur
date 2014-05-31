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

      def initialize(opts={})
        super(opts)
      end

      def carve(grid)
	grid.build_space(self.dup)
      end

      def carve!(grid)
	grid.build_space!(self) 
      end
    end
  end
end
