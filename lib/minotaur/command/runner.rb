require 'rubygems'
require 'thor'
require 'highline/import'

#require "curses"

module Minotaur
  module Command


    #
    #  a little thor app to expose some useful utilities
    #
    class Runner < Thor

      desc "explore", 'explore a world'
      def explore
        explorer.explore!
      end

      private
      def explorer
        @explorer ||= Minotaur::Explorer::Explorer.new
      end



    end
  end
end