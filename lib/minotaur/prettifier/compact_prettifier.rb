module Minotaur
  module Prettifier
    class CompactPrettifier < Base
      def prettify(grid, _) #, path=[])
        output = " " + "_" * (grid.width * 2 - 1) << "\n"
        grid.height.times do |y|
          output << "|"
          grid.width.times do |x|
            output << cell(grid,x,y) #,path)
          end
          output << "\n"
        end
        output
      end

      private

      def cell(grid,x,y) #,path)
        output = ""
        pos = Position.new(x,y)

        #if !path.empty? && path.include?(pos)
        #  output << if pos == path.first
        #    path_start_indicator
        #  elsif pos == path.last
        #    path_end_indicator
        #  else
        #    path_indicator
        #  end
        #else
          output << (grid.passable?(pos,SOUTH) ? " " : "_")
        #end

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