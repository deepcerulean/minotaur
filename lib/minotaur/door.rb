module Minotaur
  # a door represents a connection between two rooms
  class Door
    #include Support::FateHelpers

    #attr_accessor :material_strength, :condition
    #attr_accessor :locked

    attr_accessor :connected_rooms

    def initialize(opts={})
      self.connected_rooms          = opts.delete(:connected_rooms) { [] }
      #self.material_strength        = opts.delete(:material)        { rand(10) }
      #self.condition                = opts.delete(:condition)       { rand(5)  }
      #self.locked                   = opts.delete(:locked)          { coinflip? }

      self.connected_rooms.each do |room|
        room.doors << self
      end
    end

    # we are assuming connected rooms are actually rooms, that there are at least two, that they are actually adjoining, etc.
    def carve!(grid)
      room = connected_rooms[0]
      other_room = connected_rooms[1]

      shared_edge = room.adjoining_edge(other_room)
      alpha,beta = shared_edge.sort_by { rand }.first
      start,finish = Position.new(alpha[0],alpha[1]), Position.new(beta[0],beta[1])

      grid.build_passage!(start,finish)
    end
  end
end