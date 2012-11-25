module Minotaur
  module Geometry
    #
    #   logic for splitting a line into even segments
    #
    class Splitter
      attr_accessor :count, :min_subdivision_length

      def initialize(opts={})
        self.count                    = opts.delete(:count) { 2 }
        self.min_subdivision_length   = opts.delete(:min_subdivision_length) { 2 }
      end

      def split_magnitude(magnitude)
        (magnitude/count).to_i
      end

      def split(magnitude)
        return [magnitude] if split_magnitude(magnitude) < min_subdivision_length
        split!(magnitude)
      end

      def split!(magnitude)
        width_so_far = 0
        resultant_magnitudes = []
        count.times do |index|
          next_width = index==count-1 ? (magnitude - width_so_far) : split_magnitude(magnitude)
          width_so_far = width_so_far + next_width
          resultant_magnitudes << next_width
        end
        resultant_magnitudes
      end
    end
  end
end