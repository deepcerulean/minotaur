module Minotaur
  module Geometry
    # maybe needs a more expressive name...
    class Subdivider
      attr_accessor :count, :min_subdivision_length, :variance, :recursive

      def initialize(opts={})
        self.count                  = opts.delete(:count)                   { 2 }
        self.min_subdivision_length = opts.delete(:min_subdivision_length)  { 3 }
        self.variance               = opts.delete(:variance)                { 0 }
        self.recursive              = opts.delete(:recursive)               { true }
      end

      def depth
        @depth ||= 0
      end

      MAX_DEPTH = 25
      def subdivide(space,opts={})
        depth = opts.delete(:depth) { 0 }
        depth = depth + 1

        reached_size_limit = (space.width < min_subdivision_length || space.height < min_subdivision_length)

        return [space] if reached_size_limit || (recursive && depth > MAX_DEPTH)

        direction  = opts.delete(:direction) do
          favorable_split_direction(space, min_subdivision_length)
        end

        resultant_subdivisions = if direction == 'horizontal'
          horizontal_subdivide(space)
        elsif direction == 'vertical'
          vertical_subdivide(space)
        end

        if recursive
          resultant_subdivisions.map! { |s| subdivide(s,opts.merge!({depth: depth})) }
        end

        resultant_subdivisions.flatten
      end

      private

      def favorable_split_direction(space,min_edge_length)
        if space.width < min_edge_length
          'horizontal'
        elsif space.height < min_edge_length
          'vertical'
        else
          coinflip? ? 'horizontal' : 'vertical'
        end
      end

      def vertical_subdivide(space)
        resultant_subdivisions = []
        total_width = 0
        split_and_mutate!(space.width).each do |next_width|
          resultant_subdivisions << space.class.new(
            location: space.location.translate(EAST,total_width),
            width:    next_width,
            height:   space.height
          )
          total_width = total_width + next_width
        end
        resultant_subdivisions
      end

      def horizontal_subdivide(space)
        resultant_subdivisions = []
        total_height = 0
        split_and_mutate!(space.height).each do |next_height|
          resultant_subdivisions << space.class.new(
            location: space.location.translate(SOUTH,total_height),
            width:    space.width,
            height:   next_height
          )
          total_height = total_height + next_height
        end
        resultant_subdivisions
      end

      def splitter
        @splitter ||= Geometry::Splitter.new({count: count, min_subdivision_length: min_subdivision_length})
      end

      def mutator
        @mutator ||= Geometry::Mutator.new({variance: variance, min_subdivision_length: min_subdivision_length})
      end

      def split_and_mutate!(magnitude)
        arr = splitter.split!(magnitude)
        mutator.mutate!(arr)
        arr
      end
    end
  end
end