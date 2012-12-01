module Minotaur
  DEFAULT_EXTRUDER     = Extruders::RecursiveBacktrackingExtruder
  DEFAULT_PATHFINDER   = Pathfinders::RecursiveBacktrackingPathfinder
  DEFAULT_PRETTIFIER   = Prettifiers::SimplePrettifier

  #
  #   TODO should be a good and proper dungeon generator
  #   (more than a basepoint for weaving component behavior)
  #
  #   for now just internalize all the various components
  #   (extruders, pathfinders, etc)
  #
  class Labyrinth < Geometry::Grid
    def initialize(opts={})
      super(opts)

      extruder_module   = opts.delete(:extruder)   || DEFAULT_EXTRUDER
      pathfinder_module = opts.delete(:pathfinder) || DEFAULT_PATHFINDER
      prettifier_module = opts.delete(:prettifier) || DEFAULT_PRETTIFIER

      extend extruder_module
      extend pathfinder_module
      extend prettifier_module
    end
  end
end
