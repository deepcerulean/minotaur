module Minotaur
  module Serializers
    module ArraySerializer # < Base
      include Geometry
      include Directions
      include Support::PositionHelpers

      def to_a
        # puts "--- serializing #{width}x#{height} grid to array!"
        #sleep 3
        output = []
        0.upto(height-1) do |y|
          y0 = (y*3)
          #puts "--- consider row #{y}..."
          #sleep 1
          0.upto(2) { |n| output[y0+n] = [] }
          0.upto(width-1) do |x|
            #puts "--- consider #{x}, #{y}..."
            #sleep 1
            pos = Position.new(x,y)
            north,south,east,west = passable?(pos,NORTH), passable?(pos,SOUTH), passable?(pos,EAST), passable?(pos,WEST)
	    value = stairs?(pos) ? 3 : (door?(pos) ? 2 : 0)

            x0 = (x*3)
            output[y0][x0]     = north && west ? 0 : 1
            output[y0][x0+1]   = north ? 0 : 1
            output[y0][x0+2]   = north && east ? 0 : 1
            output[y0+1][x0]   = west ? 0 : 1

            output[y0+1][x0+1] = north || south || east || west ? value : 1

            output[y0+1][x0+2] = east  ? 0 : 1
            output[y0+2][x0]   = south && west ? 0 : 1
            output[y0+2][x0+1] = south ? 0 : 1
            output[y0+2][x0+2] = south && east ? 0 : 1
            #puts "--- complete cell #{x}, #{y}"
            #sleep 1
          end
        end
        output
      end

    end
  end
end
