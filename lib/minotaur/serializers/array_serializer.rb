module Minotaur
  module Serializers
    module ArraySerializer # < Base
      include Geometry
      include Directions
      include Support::PositionHelpers

      attr_accessor :path_indicator
      attr_accessor :path_start_indicator
      attr_accessor :path_end_indicator

      # ??
      #def path_indicator;       [4] end
      #def path_start_indicator; [5] end
      #def path_end_indicator;   [6] end
      #def stairs_indicator;     [8] end
      #def door_indicator;       [9] end

      def to_a #(path=[])
        #output = []
        output = [grid_header]
        (height-1).times do |y_coordinate|
          #y_coordinate += 1
          if y_coordinate % 2 == 0
            output[y_coordinate+1] = [] # [1]
            width.times do |x_coordinate|
              position = Position.new(x_coordinate,y_coordinate)
              output[y_coordinate+1] += cell(position) #,path)
            end
            #output << "\n|"
            #output[y_coordinate+1] += [1]
            output[y_coordinate+2] = row_separator(y_coordinate+1) #,path)
          end
        end
        output += [grid_header]
        #output[height+2] = grid_header
        output
      end

      private

      def grid_header
        ([1,1] * width)
      end

      def row_separator(y_coordinate) #,path)
        output = []
        width.times do |x_coordinate|
          pos = Position.new(x_coordinate,y_coordinate)
          output += if passable?(pos,SOUTH)
            #if !path.empty? && adjacent_in_path?(pos,pos.translate(SOUTH),path)
            #  [0,path_indicator,0]#" #{path_indicator} "
            #else
              [0]
            #end
          else
            [1]
          end
          output += [1]
        end
        output
      end

      def cell(pos) #,path)
        #output = []
        #pos = Position.new(x,y)

        #output += if !path.empty? && adjacent_in_path?(pos,pos.translate(WEST),path)
        #            path_indicator
        #          else
        #            [0]
        #          end

        #output += if !path.empty? && pos == path.first
        #            path_start_indicator
        #          elsif !path.empty? && pos == path.last
        #            path_end_indicator
        #          elsif !path.empty? && path.include?(pos)
        #            path_indicator
        #          elsif stairs?(pos)
        #            [stairs]
        #          elsif door?(pos)
        #            [door]
        #          else
        #            [0]
        #          end

        #output += if !path.empty? && adjacent_in_path?(pos,pos.translate(EAST),path)
        #            path_indicator
        #          else
        #            [0]
        #          end

        output = [0]
        #puts "--- trying to determine if position is passable to the east (#{pos})"
        east_block =  if pos.x < width && pos.y < height && passable?(pos,EAST)
                        #if !path.empty? && adjacent_in_path?(pos,pos.translate(EAST),path)
                        #  path_indicator
                        #else
                        [0]
                        #end
                      else
                        [1]
                      end
        #puts "--- output: #{output} and east block #{east_block}"
        output + east_block

      end


      def stairs?(_); false end
      def door?(_);   false end
    end
  end
end
