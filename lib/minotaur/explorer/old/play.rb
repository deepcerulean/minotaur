
class Minotaur::Play < Chingu::GameState

  trait :viewport

  def initialize(options={})
    super(options)
    self.viewport.game_area = [0,0,4000,4000]   # Set scrolling limits, the effective game world if you so will
    #self.viewport.lag = 0


    #@dungeon = Minotaur::Dungeon.create(:x => 20, :y => 20)


      #
      #viewport.lag      = 0.95              # Set a lag-factor to use in combination with x_target / y_target
      #viewport.x_target = 100               # This will move viewport towards X-coordinate 100, the speed is determined by the lag-parameter.


    @labyrinth = Minotaur::Labyrinth.new(
        width:    50,
        height:   50,
        extruder: Minotaur::Extruders::AssemblingRoomExtruder
    )
    # puts "--- reticulating splines, please wait..."
    @labyrinth.extrude!

    @tiles = []
    @labyrinth.each_position do |position|
      #puts "--- creating new tile at #{position} (open? #{@labyrinth.open?(position)})"
      @tiles << Minotaur::DungeonTile.create(
          :x => position.x*39,
          :y => position.y*39,
          :image => Image[@labyrinth.empty?(position) ? 'tile-dark.png' : 'tile-light.png']
      )
    end



    @player = Minotaur::Player.create(:x => 2000, :y => 2000) # $width/2, :y => $height/2)
    @player.input = {
        holding_left: :move_left, holding_right: :move_right,
        holding_up: :move_up, holding_down: :move_down
    }
  end


  def update
    super
    #self.caption = "FPS: #{self.fps} milliseconds_since_last_tick: #{self.milliseconds_since_last_tick}"
    self.viewport.center_around(@player)        # Center viweport around an object which responds to x() and y()

  end


end
