module Minotaur
  module Geometry
    class Mutator
      attr_accessor :variance, :rounds, :min_subdivision_length
      def initalize(opts={})
        self.variance               = opts.delete(:variance)           { 2 }
        self.rounds                 = opts.delete(:rounds)             { 3 }
        self.min_subdivision_length = opts.delete(:min_subdivision_length) { 1 }
      end

      def mutate!(arr)
        raise "Not implemented"
        #arr.each do |a|
        #  arr.each do |b|
        #    #unless arr.index(a) == arr.index(b)
        #      # mutate values slightly
        #      existing_value = arr[arr.index(b)]
        #      val = (rand(variance**2)-variance**2/2).to_i
        #      val = rand(variance).to_i while existing_value - val >= min_subdivision_length
        #
        #      arr[arr.index(a)] = arr[arr.index(a)] + val
        #      arr[arr.index(b)] = arr[arr.index(b)] - val
        #    end
        #  end
        #end
      end
    end
  end
end