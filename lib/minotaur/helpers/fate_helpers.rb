module Minotaur
  module Helpers
    #
    #   general utilities around random numbers
    #
    module FateHelpers
      def coinflip?; rand > 0.5 end
    end
  end
end