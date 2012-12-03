#module Minotaur
#  module Explorer

    class Minotaur::Window < Chingu::Window
      attr_accessor :width, :height
      def initialize(opts={})
        @width  = opts.delete(:width) { 1024 }
        @height = opts.delete(:height) { 800 }
        super(640,480,false)              # leave it blank and it will be 800,600,non fullscreen
        self.input = { :escape => :exit } # exits example on Escape

        $labyrinth = Minotaur::Labyrinth.new(
            width:    @width/40,
            height:   @height/40,
            extruder: Minotaur::Extruders::AssemblingRoomExtruder
        )
        $labyrinth.extrude!

        @tiles = []
        $labyrinth.each_position do |position|
          #puts "--- creating new tile at #{position} (open? #{@labyrinth.open?(position)})"
          @tiles << Minotaur::DungeonTile.create(:x => position.x*40, :y => position.y*40,
                                              :image => Image[$labyrinth.empty?(position) ? 'tile-dark.png' : 'tile-light.png'])
        end

        #@dungeon = Minotaur::Dungeon.create(:x => 20, :y => 20)


        @player = Minotaur::Player.create(:x => 200, :y => 200, :image => Gosu::Image["fighter.png"])
        @player.input = {
            holding_left: :move_left, holding_right: :move_right,
            holding_up: :move_up, holding_down: :move_down
        }

      end

      def update
        super
        self.caption = "FPS: #{self.fps} milliseconds_since_last_tick: #{self.milliseconds_since_last_tick}"
      end



    end
#  end
#end