module Minotaur
  module Geometry
    module Directions
      NORTH, SOUTH, EAST, WEST = 1, 2, 4, 8

      DX         = { EAST => 1, WEST => -1, NORTH =>  0, SOUTH => 0 }
      DY         = { EAST => 0, WEST =>  0, NORTH => -1, SOUTH => 1 }
      OPPOSITE   = { EAST => WEST, WEST =>  EAST, NORTH =>  SOUTH, SOUTH => NORTH }
    end
  end
end