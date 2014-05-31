module Minotaur
  # a door represents a connection between two rooms
  class Door
    include Geometry
    attr_accessor :location
    def initialize(opts={})
      self.location = opts.delete(:location) { origin }
    end
  end
end
