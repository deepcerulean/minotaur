module Minotuar
  module Helpers
    module RangeHelpers

      def range_overlap?(r1,r2)
        r1.include?(r2.begin) || r2.include?(r1.begin)
      end

      def range_overlap(r1,r2)
        [r1.begin,r2.begin].max..[r1.end,r2.end].min
      end
    end
  end
end