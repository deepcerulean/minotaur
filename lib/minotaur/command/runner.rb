require 'rubygems'
require 'thor'
require 'highline/import'

module Minotaur
  module Command
    class Runner < Thor
      desc "explore", 'explore a world'
      def explore
        explorer = Minotaur::Explorer::Explorer.new
        explorer.explore!
      end
    end
  end
end