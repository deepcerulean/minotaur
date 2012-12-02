module Minotaur
  #
  #   at this point not much more than a space, which can carve itself into a grid
  #   eventually should support custom features, atmosphere notes, treasure, encounters, etc.
  #
  class Room < Geometry::Space
    include Support::PositionHelpers
    include Support::ThemeHelpers

    attr_accessor :doors
    attr_accessor :features

    # TODO generate rooms FIRST and THEN place... hmmm
    def initialize(opts={})
      super(opts)

      # NOTE we are assuming the 'room' generator returns
      #      hash of features.... would be nice to 'safeguard' this
      self.features = opts.delete(:features) do
        generate(:room_features, :target => self)
      end
    end

    def passages
      doors.each do |door|
        { :to => [door.connected_rooms - self], :via => door }
      end
    end

    def doors
      @doors ||= []
    end

    def method_missing(sym, *args, &block)
      return self.features.send(sym) if self.features.respond_to?(sym)
      super(sym, *args, &block)
    end
  end
end