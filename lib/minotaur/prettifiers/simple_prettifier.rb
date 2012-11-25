module Minotaur
  module Prettifiers
    module SimplePrettifier # < Base
      include Geometry
      include Directions

      attr_accessor :path_indicator
      attr_accessor :path_start_indicator
      attr_accessor :path_end_indicator

      def path_indicator;       @path_indicator       ||= '.' end
      def path_start_indicator; @path_start_indicator ||= 'a' end
      def path_end_indicator;   @path_end_indicator   ||= 'b' end

      def to_s(path=[])
        output = "\n"
        output << grid_header
        height.times do |y_coordinate|
          output << "|"
          width.times do |x_coordinate|
            position = Position.new(x_coordinate,y_coordinate)
            output << cell(position,path)
          end
          output << "\n|"
          output << row_separator(y_coordinate,path)
          output << "\n"
        end
        output
      end

      private

      def grid_header
        "/" + ("---|" * width) << "\n"
      end

      def row_separator(y_coordinate,path)
        output = ""
        grid.width.times do |x_coordinate|
          pos = Position.new(x_coordinate,y_coordinate)
          output << if passable?(pos,SOUTH)
            if !path.empty? && adjacent?(pos,pos.translate(SOUTH),path)
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

      def cell(pos,path)
        output = ""
        #pos = Position.new(x,y)

        output << if !path.empty? && adjacent?(pos,pos.translate(WEST),path)
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

        output << if !path.empty? && adjacent?(pos,pos.translate(EAST),path)
          path_indicator
        else
          " "
        end

        output << if passable?(pos,EAST)
          if !path.empty? && adjacent?(pos,pos.translate(EAST),path)
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