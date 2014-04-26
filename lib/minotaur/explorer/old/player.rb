class Minotaur::Player < Chingu::GameObject
  include Minotaur::Geometry::Directions

  def initialize(opts={})
    super(opts.merge!(:image => Gosu::Image["fighter.png"]))
  end

  #def to_position
  #  Minotaur::Geometry::Position.new((@x/40).to_i+1,(@y/40).to_i+1)
  #end

  def move_left;  @x -= 3 end # unless $window.labyrinth.empty?(to_position.translate(WEST)) end
  def move_right; @x += 3 end #unless $window.labyrinth.empty?(to_position.translate(EAST)) end
  def move_up;    @y -= 3 end #unless $window.labyrinth.empty?(to_position.translate(NORTH)) end
  def move_down;  @y += 3 end #unless $window.labyrinth.empty?(to_position.translate(SOUTH)) end
end