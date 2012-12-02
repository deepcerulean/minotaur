module Minotaur
  module Support
    #
    #   general utilities around random numbers
    #
    module FateHelpers
      def coinflip?(n=1); (1..n).all? { rand > 0.5 } end
    end
  end
end