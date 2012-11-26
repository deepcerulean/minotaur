module Minotaur
  # a door represents a connection between two rooms
  class Door
    include Geometry
    #include Support::FateHelpers
    #attr_accessor :features
    #attr_accessor :material_strength, :condition
    #attr_accessor :locked

    attr_accessor :first_room, :second_room
    def initialize(first,second,opts={})
      #self.features = opts.delete(:features) { generate_features! }

      self.first_room  = first
      self.second_room = second

      [first_room,second_room].each { |room| room.doors << self }
    end

    # we are assuming connected rooms are actually rooms, that there are at least two, that they are actually adjoining, etc.
    def carve!(grid)
      shared_edge  = first_room.adjoining_edge(second_room)
      alpha,beta   = shared_edge.sort_by { rand }.first
      start,finish = Position.new(alpha[0],alpha[1]), Position.new(beta[0],beta[1])
      grid.build_passage!(start,finish)
    end

    def room_connected_to(room)
      room == first_room ? second_room : first_room
    end
  end
end