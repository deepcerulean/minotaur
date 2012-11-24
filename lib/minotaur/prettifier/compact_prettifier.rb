module Minotaur
  module Prettifier
    module CompactPrettifier # < Base
      #include PrettifierBase

      def to_s #(_) #, path=[])
        output = " " + "_" * (self.width * 2 - 1) << "\n"
        self.height.times do |y|
          output << "|"
          self.width.times do |x|
            output << cell(self,x,y) #,path)
          end
          output << "\n"
        end
        output
      end

      private

      def cell(grid,x,y)
        output = ""
        pos = Position.new(x,y)
        output << (grid.passable?(pos,SOUTH) ? " " : "_")

        if grid.rows[y][x] & EAST != 0
          output << (((grid.at(pos) | grid.at(pos.translate(EAST))) & SOUTH != 0) ? " " : "_")
        else
          output << "|"
        end

        output
      end
    end
  end
end