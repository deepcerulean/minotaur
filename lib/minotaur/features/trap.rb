module Minotaur
  # encounters!
  module Features
    class Trap < Feature
      attr_accessor :difficulty
      attr_accessor :sensitivity

      def initialize(opts={})
        self.value = opts.delete(:value) { generate_value! }
      end

      def generate_value!
        # TODO more sophisticated method needed :)
        coinflip? ? 1 : 5
      end
    end
  end
end