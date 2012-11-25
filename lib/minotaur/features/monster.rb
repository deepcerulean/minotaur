module Minotaur
  # encounters!
  module Feature
    class Monster
      attr_accessor :toughness
      attr_accessor :value

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