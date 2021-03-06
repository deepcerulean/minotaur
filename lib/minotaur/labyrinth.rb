module Minotaur
  DEFAULT_EXTRUDER     = Extruders::AssemblingRoomExtruder # RecursiveBacktrackingExtruder
  DEFAULT_PATHFINDER   = Pathfinders::RecursiveBacktrackingPathfinder
  DEFAULT_PRETTIFIER   = Prettifiers::CompactPrettifier #SimplePrettifier
  DEFAULT_SERIALIZER   = Serializers::CompactArraySerializer #ArraySerializer

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
      serializer_module = opts.delete(:serializers) || DEFAULT_SERIALIZER

      extend prettifier_module
      extend extruder_module
      extend pathfinder_module
      extend serializer_module

      # extrude!
    end

    # def map
    #   to_a
    # end
  end
end
