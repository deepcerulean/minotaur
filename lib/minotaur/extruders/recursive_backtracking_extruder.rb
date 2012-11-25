module Minotaur
  module Extruders
    #
    #  contains plugin functionality for labyrinth to extrude (mazelike) hallways recursively
    #
    module RecursiveBacktrackingExtruder
      #include PositionHelpers
      #
      #  extrude hallways recursively
      #
      def extrude!(opts={})
        start = opts.delete(:start) { origin }
        # 'empty' here basically means 'unexplored'
        each_empty_adjacent_to(start) do |next_position|
          build_passage!(start,next_position)
          extrude!(start: next_position)
        end
      end
    end
  end
end