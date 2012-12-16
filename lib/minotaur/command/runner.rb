require "rubygems"
require "bundler"
Bundler.setup(:default)

require 'minotaur'
require 'thor'
require 'highline/import'

require 'minotaur/explorer/explorer'

module Minotaur
  module Command
    #
    #  a little thor app to expose some useful utilities
    #
    class Runner < Thor

      desc "explore", 'explore a world'
      def explore
        #explorer.explore!
        explorer.show
      end

      private
      def explorer
        @explorer ||= Minotaur::Window.new
      end
    end
  end
end

Minotaur::Command::Runner.start