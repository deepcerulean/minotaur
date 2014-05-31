module Minotaur
  module Explorer
    class Game
      attr_reader :dungeon, :player_name

      def initialize
	@dungeon = Minotaur::Dungeon.new
	@player_name = @dungeon.pc_name
      end
    end
  end
end
