module Minotaur
  module Support
    #
    #   general utilities around random numbers
    #
    module FateHelpers
      def coinflip?(n=1); rand > 0.5**n end
    end
  end
end