module Minotaur
  module Support
    module DirectionHelpers
      include Geometry::Directions

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
      def direction_from(alpha,beta)
        raise "No distance between #{alpha} and #{beta}" if alpha == beta
        return WEST  if alpha.x > beta.x
        return EAST  if alpha.x < beta.x
        return NORTH if alpha.y > beta.y
        return SOUTH if alpha.y < beta.y
        raise "Can't determine direction between #{alpha} and #{beta}!"
      end

    end
  end
end