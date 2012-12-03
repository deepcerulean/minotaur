#module Minotaur
  #module Explorer
    class Minotaur::Player < Chingu::GameObject
      # To change this template use File | Settings | File Templates.
      #attr_accessor :name
      #
      #attr_accessor :experience
      #attr_accessor :level
      #
      #attr_accessor :profession
      #
      #attr_accessor :current_health
      #attr_accessor :total_health
      #
      #attr_accessor :strength
      #attr_accessor :constitution

      def move_left;  @x -= 3 end
      def move_right; @x += 3 end
      def move_up;    @y -= 3 end
      def move_down;  @y += 3 end
    end
  #end
#end