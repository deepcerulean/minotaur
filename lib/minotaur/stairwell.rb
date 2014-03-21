module Minotaur
  # a stair represents a connection between levels of a dungeon
  class Stairwell
    include Geometry
    include Support::FateHelpers
    #attr_accessor :features
    #attr_accessor :material_strength, :condition
    #attr_accessor :locked

    UP = 1
    DOWN = 2
    UP_AND_DOWN = 3

    #attr_accessor :first_room, :second_room
    attr_accessor :location
    attr_accessor :access

    def initialize(opts={})
      #self.features = opts.delete(:features) { generate_features! }
      self.location = opts.delete(:location) { origin }
      self.access   = opts.delete(:access) { coinflip? ? UP : DOWN }
      #self.features = opts.delete(:features) { generate :door_features }

      #self.first_room  = first
      #self.second_room = second
      #
      #[first_room,second_room].each { |room| room.doors << self }
    end

    def up?; self.access == UP end
    def down?; self.access == DOWN end
    #
    ## we are assuming connected rooms are actually rooms, that there are at least two, that they are actually adjoining, etc.
    #def carve!(grid)
    #  shared_edge  = first_room.adjoining_edge(second_room)
    #  alpha,beta   = shared_edge.sort_by { rand }.first
    #  start,finish = Position.new(alpha[0],alpha[1]), Position.new(beta[0],beta[1])
    #  grid.build_passage!(start,finish)
    #end
    #
    #def room_connected_to(room)
    #  room == first_room ? second_room : first_room
    #end
  end
end
