module Minotaur
  module Geometry
    # Public: Various methods useful for splitting apart a length or 'magnitude'.
    #
    # Examples
    #
    #   Splitter.new(count: 3).split!(8)
    #   # => 3
    class Splitter
      attr_accessor :count, :min_subdivision_length

      def initialize(opts={})
        self.count                    = opts.delete(:count)                  { 2 }
        self.min_subdivision_length   = opts.delete(:min_subdivision_length) { 2 }
      end

      def split!(magnitude)
        split_magnitude = (magnitude/count).to_i
        return [magnitude] if split_magnitude < min_subdivision_length
        width_so_far = 0
        Array.new(count) do |index|
          next_width = index==count-1 ? (magnitude - width_so_far) : split_magnitude
          width_so_far = width_so_far + next_width
          next_width
        end
      end
    end
  end
end