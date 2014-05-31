module Minotaur
  #
  # a city is a permanent settlement!
  #
  class City
    def economic_output
      { wood: 3, gold: 3, iron: 2 }
    end

    def stockpile
      @stockpile ||= {}
    end

    def step!
      @population = @population + 1

      economic_output.each do |resource, amount|
	stockpile[resource] ||= 0
	stockpile[resource] = stockpile[resource] + amount
      end
    end

    def population
      @population ||= 10_000
    end
  end
end
