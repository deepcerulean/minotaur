module Minotaur
  module Geometry
    class Mutator
      attr_accessor :variance, :rounds, :min_subdivision_length
      def initialize(opts={})
        self.variance               = opts.delete(:variance)           { 2 }
        self.rounds                 = opts.delete(:rounds)             { 3 }
        self.min_subdivision_length = opts.delete(:min_subdivision_length) { 1 }
      end

      def mutate!(arr)
        #p arr
        return arr unless arr.size > 1
        #raise "Not implemented"
        arr.each do |a|
          (arr-[a]).shuffle.each do |b|
            cur_val  = arr[arr.index(b)]
            offset = (rand(variance)).to_i
            #next_val = cur_val - offset
            #while existing_value - val >= min_subdivision_length
            good_pick = false
            until good_pick
              offset = (rand(variance)).to_i
              next_val = cur_val - offset
              good_pick = (next_val >= min_subdivision_length)
            end

            #val = rand(variance).to_i

            arr[arr.index(a)] = arr[arr.index(a)] + offset
            arr[arr.index(b)] = arr[arr.index(b)] - offset
          end
        end
      end
    end
  end
end