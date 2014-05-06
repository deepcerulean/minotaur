module Minotaur
  module Pathfinders
    module RecursiveBacktrackingPathfinder
      attr_accessor :solution_path

      def path(start, destination)
	# puts "--- finding solution path between #{start} and #{destination}"
	return @solution_path if path_between?(start,destination)
	# puts "--- none found!"
	nil
      end

      # doesn't track visited...?
      def path_between?(start,destination,path=[])
	# print '.'
        @solution_path = path.push(start)
        return true if start == destination

        each_passable_adjacent_to(start) do |next_position|
          unless @solution_path.include?(next_position)
            if path_between?(next_position,destination,@solution_path)
              return true
            end
          end
        end

        @solution_path.pop
        false
      end
      
    end
  end
end
