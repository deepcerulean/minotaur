module Minotaur
  class Region #< Struct.new(:location, :size)
    include Support::PositionHelpers
    include Support::DirectionHelpers
    attr_accessor :location, :size

    def initialize(opts={})
      if opts.include?(:x) && opts.include?(:y)
	self.location = Position.new(opts.delete(:x), opts.delete(:y))
      elsif opts.include?(:location)
	self.location = opts.delete(:location) #{ origin }
      end

      if opts.include?(:width) && opts.include?(:height)
        self.size     = Size.new(width: opts.delete(:width), height: opts.delete(:height))
      else
        self.size     = opts.delete(:size)     { unit }
        self.size     = Size.new(width: size, height: size) if self.size.is_a? Fixnum
      end
    end

    def to_s
      output = ""
      output << "#{size}"
      output << " at #{location}" if location
      output
    end

    def location
      @location ||= origin
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

    def contains?(position)
      position.x >= location.x && position.y >= location.y && position.x <= location.x + self.width - 1 && position.y <= location.y+self.height - 1
    end

    def perimeter?(position)
      position.x == location.x || position.y == location.y || position.x == location.x + self.width - 1 || position.y == location.y + self.height - 1
    end

    def northern_edge
      (0...self.width).map do |i|
	Geometry::Position.new(self.x + i,self.y)
      end
    end

    def western_edge
      (0...self.height).map do |i|
	Geometry::Position.new(self.x, self.y + i)
      end
    end

    def southern_edge
      northern_edge.map { |pos| pos + Geometry::Position.new(0,self.height-1) }
    end

    def eastern_edge
      western_edge.map { |p| p + Geometry::Position.new(self.width-1,0) }
    end

    def edge_for(direction)
      case direction
      when NORTH then northern_edge
      when EAST then eastern_edge
      when SOUTH then southern_edge
      when WEST then western_edge
      end
    end

    def perimeter
      all_directions.map { |d| edge_for(d) }.flatten.uniq
    end

    def outer_edge_for(direction)
      case direction
      when NORTH then northern_edge.map { |p| p + Geometry::Position.new(0,-1) }
      when EAST  then eastern_edge.map  { |p| p + Geometry::Position.new(1,0) }
      when SOUTH then southern_edge.map { |p| p + Geometry::Position.new(0,1)  }
      when WEST  then western_edge.map  { |p| p + Geometry::Position.new(-1,0)  }
      end
    end

    def outer_perimeter
      all_directions.map { |d| outer_edge_for(d) }.flatten.uniq
    end

    def direction_for_perimeter_position(position)
      all_directions.detect { |direction| edge_for(direction).include?(position) }
    end

    def direction_for_outer_perimeter_position(position)
      all_directions.detect { |direction| outer_edge_for(direction).include?(position) }
    end

  end
end
