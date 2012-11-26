module Minotaur
  module Prettifier
    module CompactPrettifier
      include Geometry

      def to_s
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

        if grid.rows[y][x] & EAST != 0
          output << (((at(position) | at(position.translate(EAST))) & SOUTH != 0) ? " " : "_")
        else
          output << "|"
        end

        output
      end
    end
  end
end