module Minotaur
  module Features
    class Alignment < Feature
      attr_accessor :moral_alignment, :ethical_alignment
      def initialize(moral,ethical,opts={})
        self.moral_alignment   = moral
        self.ethical_alignment = ethical
      end

      def to_s
        "#{ethical_alignment} #{moral_alignment}"
      end
    end
  end
end