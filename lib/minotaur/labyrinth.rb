module Minotaur
  DEFAULT_EXTRUDER     = Extruders::RecursiveBacktrackingExtruder
  DEFAULT_PATHFINDER   = Pathfinders::RecursiveBacktrackingPathfinder

  #
  #   TODO proper dungeon generator
  #   (basepoint for weaving component behavior)
  #
  #   for now just internalize all the various components
  #   (extruders, pathfinders, etc)
  #
  class Labyrinth < Grid
    attr_accessor :size
    attr_accessor :extruder_module, :pathfinder_module

    def initialize(opts={})
      self.size   = opts.delete(:size)
      self.width  = self.size || opts.delete(:width)  { DEFAULT_SIZE }
      self.height = self.size || opts.delete(:height) { DEFAULT_SIZE }
      self.extruder_module   = opts.delete(:extruder)   || DEFAULT_EXTRUDER
      self.pathfinder_module = opts.delete(:pathfinder) || DEFAULT_PATHFINDER

      super(self.width, self.height)

      extend extruder_module
      extend pathfinder_module
    end
  end
end