module Minotaur
  module Geometry
    class Splitter
      attr_accessor :count, :min_subdivision_length

      def initialize(opts={})
        self.count                = opts.delete(:count) { 2 }
        self.min_subdivision_length   = opts.delete(:min_subdivision_length) { 2 }
      end

      def split!(magnitude)
        split_magnitude     = (magnitude/count).to_i
        return [magnitude] if split_magnitude < min_subdivision_length

        width_so_far = 0
        resultant_magnitudes = []
        count.times do |index|
          next_width = split_magnitude
          if index==count-1
            next_width = (magnitude - width_so_far)
          end
          width_so_far = width_so_far + next_width
          resultant_magnitudes << next_width
        end
        resultant_magnitudes
      end
    end
  end
end