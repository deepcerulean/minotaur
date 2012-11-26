require 'rubygems'
require 'thor'
require 'highline/import'


module Minotaur
  module Command
    class Runner < Thor
      desc "explore", 'explore a world'
      def explore
        #puts "I'm a thor task!"
        #labyrinth = Minotaur::Labyrinth.new(width: 10, height: 10, extruder: Extruders::SubdividingRoomExtruder)
        #labyrinth.extrude!
        #puts "In the context of Minotaur: #{labyrinth}"
        explorer = Minotaur::Explorer::Explorer.new #(labyrinth:labyrinth)
        explorer.explore!
      end

      desc "generate", 'generate a world'
      def generate
        puts "--- more to come soon!"
      end
    end
  end
end