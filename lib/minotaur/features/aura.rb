module Minotaur
  module Features
    class Aura < Feature
      attr_accessor :alignment
      def initialize(opts={})
        self.alignment = opts.delete(:alignment) { generate(:alignment) }
      end
    end
  end
end