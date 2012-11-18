module Minotaur
  module Pathfinders
    module RecursiveBacktrackingPathfinder
      attr_accessor :solution_path

      def path_between?(origin,destination=Position.origin,path=[])
        self.solution_path ||= []

        self.solution_path.push(origin)
        #puts to_s(solution_path)

        if origin == destination
          return true
        end

        each_passable_adjacent_to(origin) do |next_position|
          unless self.solution_path.include?(next_position)
            if path_between?(next_position,destination)
              return true
            end
          end
        end

        self.solution_path.pop
        false
      end
    end
  end
end