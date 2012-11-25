module Minotaur
  #
  #   at this point not much more than a space, which can carve itself into a grid
  #   eventually should support custom features, atmosphere notes, treasure, encounters, etc.
  #
  class Room < Geometry::Space
    attr_accessor :doors
    attr_accessor :features

    def initialize(opts={})
      self.features      = opts.delete(:features)   { [] } # Feature.generate_suite!(self) }
      #self.treasure     = opts.delete(:treasure)   { Treasure.generate! }
      #self.monsters     = opts.delete(:monsters)   { Monster.generate! }
      #self.traps        = opts.delete(:traps)      { Trap.generate! }
      #self.atmosphere   = opts.delete(:atmosphere) { Atmosphere.generate! }
      super(opts)


    end

    def doors
      @doors ||= []
    end


  end
end