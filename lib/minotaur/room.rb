module Minotaur
  #
  #   at this point not much more than a space, which can carve itself into a grid
  #   eventually should support custom features, atmosphere notes, treasure, encounters, etc.
  #
  class Room < Geometry::Space
    include Support::ThemeHelpers

    attr_accessor :doors
    #attr_accessor :features

    attr_accessor :type
    attr_accessor :name
    attr_accessor :aura
    attr_accessor :atmosphere

    def initialize(opts={})
      super(opts)

      self.type         = opts.delete(:type)       { generate :room_type, for: self }
      # attempt to generate these in case they weren't generated automatically by the room type... (i guess?)
      #puts "--- self.aura? #{!self.aura.nil?}"
      #p self.aura
      self.aura         ||= opts.delete(:aura)       { generate(:aura) } #: self.aura } #            unless
      #puts "--- after generating (or leaving alone):"
      #p self.aura
      self.atmosphere   ||= opts.delete(:atmosphere) { generate(:atmosphere) } #      unless self.atmosphere }

      #puts "--- about to generate name!"
      #puts "--- current aura: #{self.aura}"
      self.name         ||= opts.delete(:name)       { generate(:name, for: self) } #3  unless self.name }
      #self.features      = opts.delete(:features)   { Feature.generate } # Feature.generate_suite!(self) }
      #self.treasure     = opts.delete(:treasure)   { Treasure.generate! }
      #self.monsters     = opts.delete(:monsters)   { Monster.generate! }
      #self.traps        = opts.delete(:traps)      { Trap.generate! }
    end

    def passages
      doors.each do |door|
        { :to => [door.connected_rooms - self], :via => door }
      end
    end

    def doors
      @doors ||= []
    end

    def to_s
      name.to_s
    end

  end
end