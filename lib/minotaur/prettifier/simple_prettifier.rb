module Minotaur
  module Prettifier
    class SimplePrettifier < Base
      def prettify(grid,path=[])
        output = grid_header(grid) #row_separator(grid,0,path) #grid_header(grid)
        #output << "\n"
        grid.height.times do |y|
          output << "|"
          grid.width.times do |x|
            output << cell(grid,x,y,path)
          end
          output << "\n|"
          output << row_separator(grid,y,path)
          output << "\n"
        end
        output
      end

      private

      def grid_header(grid)
        "/" + ("---|" * grid.width) << "\n"
      end

      def row_separator(grid,y,path)
        output = ""
        grid.width.times do |x|
          pos = Position.new(x,y)
          output << if grid.passable?(pos,SOUTH)
            if !path.empty? && grid.adjacent?(pos,pos.translate(SOUTH),path)
              " #{path_indicator} "
            else
              "   "
            end
          else
            "-" * 3
          end
          output << "|"
        end
        output
      end

      def cell(grid,x,y,path)
        output = ""
        pos = Position.new(x,y)

        output << if !path.empty? && grid.adjacent?(pos,pos.translate(WEST),path)
          path_indicator
        else
          " "
        end

        output << if !path.empty? && pos == path.first
          path_start_indicator
        elsif !path.empty? && pos == path.last
          path_end_indicator
        elsif !path.empty? && path.include?(pos)
          path_indicator
        else
          ' '
        end

        output << if !path.empty? && grid.adjacent?(pos,pos.translate(EAST),path)
          path_indicator
        else
          " "
        end

        output << if grid.passable?(pos,EAST)
          if !path.empty? && grid.adjacent?(pos,pos.translate(EAST),path)
            path_indicator
          else
            " "
          end
        else
          "|"
        end

        output
      end
    end
  end
end