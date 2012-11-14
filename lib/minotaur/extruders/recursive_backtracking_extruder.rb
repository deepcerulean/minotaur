module Minotaur
  module Extruders
    class RecursiveBacktrackingExtruder
      def extrude!(labyrinth,origin=Position.origin)
        puts "=== RecursiveBacktrackingExtruder#extrude"
        puts "--- labyrinth state: "
        puts labyrinth
        puts "--- Attempting to determine empty adjacent spaces to #{origin}"
        labyrinth.empty_adjacent_from(origin).each do |next_position|
          # hmmm, didn't need this before? enumerator magic?
          next unless labyrinth.empty?(next_position)
          puts "--- Considering space #{next_position} (adjacent to #{origin})..."
          direction = Direction.from(origin,next_position)
          puts "--- It is #{Direction.humanize(direction)} from #{origin}"

          #labyrinth.mark!(origin, direction)
          #labyrinth.mark!(next_position, Direction.opposite(direction))
          puts "--- Building passage..."
          labyrinth.build_passage!(origin,next_position)
          extrude!(labyrinth,next_position)
        end
      end
    end
  end
end