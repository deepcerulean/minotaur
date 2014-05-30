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

    attr_accessor :entities

    # TODO generate rooms FIRST and THEN place... hmmm
    def initialize(opts={})
      super(opts)

      # NOTE we are assuming the 'room' generator returns
      #      hash of features.... would be nice to 'safeguard' this
      self.features = opts.delete(:features) do
        generate(:room_features, self) #:target => self)
      end

      self.adjacent_rooms = []
      self.adjacent_room_directions = { NORTH => [], SOUTH => [], EAST => [], WEST => [] }
      self.connected_rooms = []
      self.placed = false

      # self.gold = self.features.treasure.gold.map do |gp|
      #   { :amount => gp.amount, :location 
      # end

      # self.contained_entities = []
      place_entities

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

    def occupied_positions
      @occupied_positions ||= []
    end

    def unoccupied_positions
      all_positions - occupied_positions
    end

    def place_entities
      @entities = []
      @occupied_locations = []
      # binding.pry if features.nil?
      return if features.nil?
      entities_to_place = [ features.monsters, features.treasure.gold, features.treasure.potions, features.treasure.scrolls ].compact.flatten
      entities_to_place.each { |entity| place_entity(entity) }
      @entities
    end

    def place_entity(entity)
      return false if unoccupied_positions.empty?
      location = unoccupied_positions.sample
      attrs = entity_attributes(type: entity.type, subtype: entity.subtype, location: location)
      attrs = attrs.merge(entity.properties) if entity.properties.is_a?(Hash)
      entity_struct = OpenStruct.new(attrs)
      @entities << entity_struct
    end

    def entity_attributes(attrs={})
      attrs.merge({guid: SecureRandom.uuid})
    end
  end # Room
end # Roguecraft
