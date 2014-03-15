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
    attr_accessor :adjacent_rooms, :adjacent_room_directions
    attr_accessor :connected_rooms
    attr_accessor :placed

    # TODO generate rooms FIRST and THEN place... hmmm
    def initialize(opts={})
      super(opts)

      # NOTE we are assuming the 'room' generator returns
      #      hash of features.... would be nice to 'safeguard' this
      self.features = opts.delete(:features) do
        generate(:room_features, :target => self)
      end

      self.adjacent_rooms = []
      self.adjacent_room_directions = { NORTH => [], SOUTH => [], EAST => [], WEST => [] }
      self.connected_rooms = []
      self.placed = false
    end

    def connected?(other_room); self.connected_rooms.include?(other_room) end

    def directions_without_adjacent_rooms
      self.adjacent_room_directions.keys.select { |direction| self.adjacent_room_directions[direction].empty? }
    end

    def placed?; self.placed end

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
