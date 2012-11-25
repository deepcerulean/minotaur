module Minotaur
  module Geometry
    #
    #   mutate values and arrays
    #
    class Mutator
      attr_accessor :variance, :rounds, :min_subdivision_length

      def initialize(opts={})
        self.variance               = opts.delete(:variance)           { 0 }
        self.rounds                 = opts.delete(:rounds)             { 3 }
        self.min_subdivision_length = opts.delete(:min_subdivision_length) { 1 }
      end

      def mutate!(arr)
        return arr unless arr.size > 1
        rounds.times do
          arr.each do |a|
            arr.each do |b|
              # this index-dancing is (trying to) handle the case where there are duplicates...
              alpha = arr.index(a)
              beta = arr.rindex(b)
              next if alpha == beta || !alpha || !beta
              offset = (rand(variance)).to_i
              good_pick = false
              until good_pick
                offset = (rand(variance)).to_i
                next_val = b - offset
                good_pick = (next_val >= min_subdivision_length)
              end
              arr[alpha] = a + offset
              arr[beta]  = b - offset
            end
          end
        end
      end
    end
  end
end