module Minotaur
  #
  # a city is a permanent settlement
  #
  class City
    def step!
      @population = @population + 1
    end

    def population
      @population ||= 10_000
    end
  end
end
