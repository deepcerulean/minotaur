module Minotaur
  #
  #   at this point not much more than a space, which can carve itself into a grid
  #   eventually should support custom features, atmosphere notes, treasure, encounters, etc.
  #
  class Room < Geometry::Space
    def carve!(grid)
      Geometry::Grid.each_position(width,height) do |position|
        real_position = location + position
        grid.build_passage!(real_position,real_position.translate(WEST))  unless real_position.x <= location.x
        grid.build_passage!(real_position,real_position.translate(NORTH)) unless real_position.y <= location.y
        grid.build_passage!(real_position,real_position.translate(EAST))  unless real_position.x >= location.x + width - 1
        grid.build_passage!(real_position,real_position.translate(SOUTH)) unless real_position.y >= location.y + height - 1
      end
    end
  end
end