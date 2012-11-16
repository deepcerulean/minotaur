module Minotaur
  DEFAULT_EXTRUDER     = Extruders::RecursiveBacktrackingExtruder
  DEFAULT_PATHFINDER   = Pathfinders::RecursiveBacktrackingPathfinder
  #
  #   proper dungeon generator
  #   for now just internalize all the various components (extruders, pathfinders, etc)
  #
  class Labyrinth < Grid
    attr_accessor :size
    attr_accessor :extruder_module, :pathfinder_module

    def initialize(opts={})
      self.size   = opts.delete(:size)
      self.width  = self.size || opts.delete(:width)  { DEFAULT_SIZE }
      self.height = self.size || opts.delete(:height) { DEFAULT_SIZE }

      super(self.width, self.height)

      self.extruder_module   = opts.delete(:extruder)   || DEFAULT_EXTRUDER
      self.pathfinder_module = opts.delete(:pathfinder) || DEFAULT_PATHFINDER

      #puts "--- including extruder #{extruder_module}"
      extend extruder_module
      #puts "--- including pathfinder #{pathfinder_module}"
      extend pathfinder_module
    end
    #
    #def carve_passages!(origin=Position.origin)
    #  extruder.extrude!(self,origin)
    #end
    #
    #def path_between(origin,destination)
    #  pathfinder.path_between(self,origin,destination)
    #end
  end
end