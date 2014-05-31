module Minotaur
  module Prettifiers
    module CompactPrettifier
      include Geometry
      include Geometry::Directions

      def to_s(*args) # ignore args?
        output = " " + "_" * (self.width * 2 - 1) << "\n"
        self.height.times do |y_coordinate|
          output << "|"
          self.width.times do |x_coordinate|
            output << cell(Position.new(x_coordinate,y_coordinate))
          end
          output << "\n"
        end
        output
      end

      private

      def cell(position)
        output = ""
        output << (passable?(position,SOUTH) ? " " : "_")

        if self.rows[position.y][position.x] & EAST != 0
	  # if stairs.any? { |s| s.location == position } #2 (self.rows[position.y][position.x].stairs?)
	  #   outputs << '<'
	  # else
	  output << (((at(position) | at(position.translate(EAST))) & SOUTH != 0) ? " " : "_")
	 #  end
        else
          output << "|"
        end

        output
      end
    end
  end
end
