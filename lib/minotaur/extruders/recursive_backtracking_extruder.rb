module Minotaur
  module Extruders
    module RecursiveBacktrackingExtruder
      def carve_passages!(origin=Position.origin)
        each_empty_adjacent_to(origin) do |next_position|
          build_passage!(origin,next_position)
          carve_passages!(next_position)
        end
      end
    end
  end
end