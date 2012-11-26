module Minotaur

  # notes on the atmosphere of the space
  module Features
    class Atmosphere < Feature
      attr_accessor :description
      attr_accessor :temperature


      def initialize(opts={})
        self.description = opts.delete(:description)
        self.temperature = opts.delete(:temperature)
      end

      def to_s
        output = ""
        output << description if description
        output << "The temperature is #{temperature}" if temperature
        output
      end
    end
  end
end