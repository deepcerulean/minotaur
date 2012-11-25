module Minotaur
  module Explorer
    class Explorer
      attr_accessor :labyrinth, :current_location
      def initialize(opts={})
        self.current_location = opts.delete(:current_location) { origin }
        self.labyrinth        = opts.delete(:labyrinth) { Labyrinth.new(:width => 10, :height => 10) }
      end
    end
  end
end

# TODO a tool to traverse through a generated space in a text-mode kind of way
#      should maybe show off the 'dynamic' generative aspects of the project
#      (i.e., a dungeon created as you walk through it...)