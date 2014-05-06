module Minotaur
  module Server
    #
    #  The idea is to prebuild a bunch of dungeons
    #  We should also accept themes from outside...
    #  
    #  GET /worlds/1.json       
    #  GET /[entity]/[:id]
    #
    #  POST /worlds/new
    #    [name: string, cities: integer, width: integer, height: integer ]
    #
    class Engine
      def initialize

      end

      def run
	# 
	# host some server process, i'm thinking of exposing it over DrB maybe?
	#
	#
      end
    end
  end
end
