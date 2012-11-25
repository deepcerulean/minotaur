module Minotaur
  module Support
    module RangeHelpers
      def range_overlap?(range_one,range_two)
        range_one.include?(range_two.begin) || range_two.include?(range_one.begin)
      end

      def range_overlap(range_one,range_two)
        [range_one.begin,range_two.begin].max..[range_one.end,range_two.end].min
      end
    end
  end
end