module Minotaur
  module Geometry
    #
    #   tools to mutate values and arrays
    #
    class Mutator
      attr_accessor :variance, :rounds, :min_subdivision_length

      def initialize(opts={})

        self.variance               = opts.delete(:variance)               { 0 }
        self.rounds                 = opts.delete(:rounds)                 { 3 }
        self.min_subdivision_length = opts.delete(:min_subdivision_length) { 1 }
      end

      def mutate!(arr)
        return arr if arr.empty? || variance == 0

        rounds.times do
          arr.each do |a|
            arr.each do |b|
              # this index-dancing is (trying to) handle the possible case where there are duplicates...
              alpha = arr.index(a)
              beta = arr.rindex(b)
              next if alpha == beta || !alpha || !beta
              offset = shuffle_offset(b-min_subdivision_length)
              arr[alpha] = a + offset
              arr[beta]  = b - offset
            end
          end
        end
      end

      #def random_offset; (rand(variance**2)-rand(variance**2)/2).to_i end

      def shuffle_offset(min)
        offset = min
        offset = min + rand(variance).to_i until offset >= min
        offset
      end
    end
  end
end