module Minotaur
  module Serializers
    # compact serializer
    module CompactArraySerializer
      include Geometry
      include Directions
      include Support::PositionHelpers

      def to_a
        output = []
        0.upto(height-1) do |y|
	  output[y] = []
          0.upto(width-1) do |x|
            pos = Position.new(x,y)
            # north,south,east,west = passable?(pos,NORTH), passable?(pos,SOUTH), passable?(pos,EAST), passable?(pos,WEST)
	    
	    # value = serialized_value_for(pos)
	    output[y][x] = serialized_value_for(pos) # north || south || east || west ? value : 1
          end
        end
        output
      end

      def serialized_value_for(pos)
	if stairs?(pos)
	  if stairs_up?(pos)
	    3
	  else
	    4
	  end
	elsif door?(pos)
	  2
	else
          north,south,east,west = passable?(pos,NORTH), passable?(pos,SOUTH), passable?(pos,EAST), passable?(pos,WEST)
	  north || south || east || west ? 0 : 1
	end
      end

    end
  end
end
