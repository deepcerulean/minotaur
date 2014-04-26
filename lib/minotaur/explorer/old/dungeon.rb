class Minotaur::DungeonTile < Chingu::GameObject
  #attr_accessor :open
  #
  #def create(opts={})
  #  open = opts.delete(:open) { false }
  #  opts.merge!()
  #  super(opts)
  #end

end

#class Minotaur::Dungeon < Chingu::BasicGameObject
#  attr_accessor :labyrinth, :tiles
#
#  def create(opts={})
#
#    super(opts)
#    @labyrinth = Labyrinth.new(
#        width:    20,
#        height:   20,
#        extruder: Minotaur::Extruders::AssemblingRoomExtruder
#    )
#    @labyrinth.extrude!
#
#    @labyrinth.each_position do |position|
#      @tiles << Minotaur::DungeonTile.new(:x => position.x, :y => position.y, :open => true)
#    end
#  end
#
#  #def draw
#  #  @tiles.each do |tile|
#  #    tile.draw
#  #  end
#  #end
#end