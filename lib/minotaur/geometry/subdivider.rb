module Minotaur
  module Helpers
    module Geometry
      # maybe needs a more expressive name...
      class Subdivider
        attr_accessor :count, :min_subdivision_length, :variance, :recursive, :depth

        def initialize(opts={})
          self.count              = opts.delete(:count)               { 2 }
          self.min_subdivision_length = opts.delete(:min_subdivision_length)  { 3 }
          self.variance           = opts.delete(:variance)            { 0 }
          self.recursive          = opts.delete(:recursive)        { true }
        end

        MAX_DEPTH = 25
        def subdivide(subdivisions,opts={})
          subdivisions_after_subdivide = []
          subdivisions.each do |subdivision|
            reached_size_limit = (subdivision.width < min_subdivision_length || subdivision.height < min_subdivision_length)
            return [self] if reached_size_limit || (recursive && depth > MAX_DEPTH)

            puts "--- Attempting to subdivide subdivision with min edge length: #{min_subdivision_length}"

            direction  = opts.delete(:direction) do
              favorable_split_direction(min_subdivision_length)
            end

            resultant_subdivisions = if direction == 'horizontal'
              horizontal_subdivide(subdivision)
            elsif direction == 'vertical'
              vertical_subdivide(subdivision)
            end

            if recursive
              depth ||= 0
              depth = depth + 1
              subdivide(resultant_subdivisions)
            end

            subdivisions_after_subdivide << resultant_subdivisions.flatten
          end

          if subdivisions_after_subdivide.empty?
            resultant_subdivisions = subdivisions
          else
            resultant_subdivisions = subdivisions_after_subdivide
          end

          resultant_subdivisions
        end

        private

        def favorable_split_direction(min_edge_length)
          if width < min_edge_length
            'horizontal'
          elsif height < min_edge_length
            'vertical'
          else
            coinflip? ? 'horizontal' : 'vertical'
          end
        end

        def vertical_subdivide(subdivision)
          resultant_subdivisions = []
          total_width = 0
          split_and_mutate!(width).each do |next_width|
            resultant_subdivisions << subdivision.class.new(location: location.translate(EAST,total_width), width: next_width,height: height)
            total_width = total_width + next_width
          end
          resultant_subdivisions
        end

        def horizontal_subdivide(subdivision)
          resultant_subdivisions = []
          total_height = 0
          split_and_mutate!(height).each do |next_height|
            resultant_subdivisions << subdivision.class.new(location: location.translate(SOUTH,total_height),width: width,height: next_height)
            total_height = total_height + next_height
          end
          resultant_subdivisions
        end

        def splitter
          @splitter ||= Splitter.new(count: count, min_subdivision_length: min_subdivision_length)
        end

        def mutator
          @mutator ||= Mutator.new(variance: variance, min_subdivision_length: min_subdivision_length)
        end

        def split_and_mutate!(magnitude)
          arr = splitter.split!(magnitude)
          mutator.mutate!(arr)
          arr
        end
      end
    end
  end
end