module Minotaur
  module Helpers
    module DirectionHelpers
      def all_directions
        [NORTH,SOUTH,EAST,WEST]
      end

      def all_directions?
        all_directions.all?
      end

      def shuffled_directions
        all_directions.sort_by { rand }
      end

      def each_direction
        all_directions.each
      end

      def direction_opposite(direction)
        OPPOSITE[direction]
      end

      def humanize_direction(direction)
        case direction
          when NORTH then "north"
          when SOUTH then "south"
          when EAST  then "east"
          when WEST  then "west"
        end
      end

      # assume no edge cases (could be made better)
      def direction_from(a,b)
        raise "No distance between #{a} and #{b}" if a == b
        return WEST  if a.x > b.x
        return EAST  if a.x < b.x
        return NORTH if a.y > b.y
        return SOUTH if a.y < b.y
        raise "Can't determine direction between #{a} and #{b}!"
      end

    end
  end
end