module Minotaur
  class World < Entity
    DEFAULT_DUNGEON_COUNT = 5
    DEFAULT_CITY_COUNT    = 3

    attr_accessor :cities, :dungeons

    def initialize(opts={})
      city_count = opts.delete(:city_count) { DEFAULT_CITY_COUNT }
      @cities = Array.new(city_count) { Minotaur::City.new }

      dungeon_count = opts.delete(:dungeon_count) { DEFAULT_DUNGEON_COUNT }
      @dungeons = Array.new(dungeon_count) { Minotaur::Dungeon.new }

      super(opts)
    end

    def population; @cities.map(&:population).reduce(&:+) end

    def economic_output
      global_economy = @cities.map(&:economic_output)
      global_economy.inject({}) do |hsh, resources|
	resources.each do |resource, amount|
	  hsh[resource] ||= 0
	  hsh[resource] = hsh[resource] + amount
	end
	hsh
      end
    end

    def step!
      @cities.each(&:step!)
    end
  end
end
