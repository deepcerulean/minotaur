module Minotaur
  class Region < Struct.new(:location, :size)
    def to_s
      "#{size} at #{location}"
    end

    def width
      size.width
    end

    def height
      size.height
    end

    def area
      size.area
    end

    def x
      location.x
    end

    def y
      location.y
    end
  end
end