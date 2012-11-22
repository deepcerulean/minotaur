module Minotaur
  module Extruders
    module RecursiveBacktrackingExtruder
      #
      #  extrude hallways recursively
      #
      def extrude!(origin=Position.origin)
        each_empty_adjacent_to(origin) do |next_position|
          build_passage!(origin,next_position)
          extrude!(next_position)
        end
      end
    end
  end
end