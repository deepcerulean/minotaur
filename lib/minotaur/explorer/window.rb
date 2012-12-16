class Minotaur::Window < Chingu::Window
  attr_accessor :width, :height
  attr_accessor :labyrinth
  #trait :viewport
  def initialize(opts={})
    @width  = opts.delete(:width) { 1024 }
    @height = opts.delete(:height) { 800 }
    super(@width,@height,false)              # leave it blank and it will be 800,600,non fullscreen
    self.input = { :escape => :exit } # exits example on Escape

    push_game_state(Minotaur::Play, :setup => false)
  end
end