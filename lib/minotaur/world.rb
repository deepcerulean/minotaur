module Minotaur
  class World < Entity
    DEFAULT_DUNGEON_COUNT = 5
    DEFAULT_CITY_COUNT = 3

    attr_accessor :cities, :dungeons

    def initialize(opts={})
      city_count = opts.delete(:city_count) { DEFAULT_CITY_COUNT }
      @cities = Array.new(city_count) { Minotaur::City.new }

      dungeon_count = opts.delete(:dungeon_count) { DEFAULT_DUNGEON_COUNT }
      @dungeons = Array.new(dungeon_count) { Minotaur::Dungeon.new }

      super(opts)

      # place them randomly on a world, generate land around them, run cellular automata...?
      # will want automata for dungeon caverns eventually anyway...
      
    end
    # def awesome?; true end
  end
end
