module Minotaur
  class Region < Entity #< Struct.new(:location, :size)
    include Support::PositionHelpers
    include Support::DirectionHelpers
    attr_accessor :location, :size
    def_delegators :@size, :height, :width, :area
    def_delegators :@location, :x, :y

    def initialize(opts={})
      if opts.include?(:x) && opts.include?(:y)
	self.location = Position.new(opts.delete(:x), opts.delete(:y))
      elsif opts.include?(:location)
	self.location = opts.delete(:location) #{ origin }
      else
	self.location = origin
      end

      if opts.include?(:width) && opts.include?(:height)
        self.size     = Size.new(width: opts.delete(:width), height: opts.delete(:height))
      else
        self.size     = opts.delete(:size)     { unit }
        self.size     = Size.new(width: size, height: size) if self.size.is_a? Fixnum
      end

      super(opts)
    end

    def to_s
      output = "#{size}"
      output << " at #{location}" if location
      output
    end

    # def location
    #   self.location ||= origin
    # end

    def each_position
      (self.x..self.x+self.width-1).each do |x_coordinate|
	(self.y..self.y+self.height-1).each do |y_coordinate|
	  yield Position.new(x_coordinate, y_coordinate)
	end
      end
    rescue
      binding.pry
    end

    def all_relative_positions
      @relative_positions ||= (0..width-1).map do |x_coordinate|
	(0..height-1).map do |y_coordinate|
	  Position.new(x_coordinate, y_coordinate)
	end
      end.flatten
    end

    def all_positions
      @all_positions ||= all_relative_positions.map { |p| p + location }
    end

    def contains?(position)
      position.x >= location.x && position.y >= location.y && position.x <= location.x + self.width - 1 && position.y <= location.y+self.height - 1
    end
    
    def relative_center
      Position.new(self.width/2, self.height/2)
    end

    def center
      relative_center + location
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

    def outer_perimeter?(pos)
      outer_perimeter.include?(pos)
    end

    def outer_corners
      [ Position.new(x-1,y-1), Position.new(x-1,y+height),
	Position.new(x+width,y-1), Position.new(x+width,y+height) ]
    end

    def outer_corner?(pos)
      outer_corners.include?(pos)
    end

    def direction_for_perimeter_position(position)
      all_directions.detect { |direction| edge_for(direction).include?(position) }
    end

    def direction_for_outer_perimeter_position(position)
      all_directions.detect { |direction| outer_edge_for(direction).include?(position) }
    end

    def vertical_range
      (y..y+height-1)
    end

    def horizontal_range
      (x..x+width-1)
    end

    def each_adjacent_space_for_direction(space, direction, offset=1)
      range = case direction
	      when NORTH, SOUTH then (((-width)+1)..(space.width-1))
	      when EAST, WEST then (((-height)+1)..(space.height-1))
	      end

      for i in range
	case direction
	when NORTH then 
	  proposed_y = space.y - height - offset
	  proposed_x = space.x + i
	when SOUTH then
	  proposed_y = space.y + space.height + 1
	  proposed_x = space.x + i
	when EAST then
	  proposed_x = space.x + space.width + 1
	  proposed_y = space.y + i
	when WEST then
	  proposed_x = space.x - width - offset
	  proposed_y = space.y + i
	end

	yield [Position.new(proposed_x, proposed_y), direction]
      end
    end

    def each_adjacent_space(space, options={}) # offset=1)
      offset    = options.delete(:offset) { 1 }
      direction = options.delete(:direction) { nil }

      directions = if direction
		     [direction]
		   else
		     shuffled_directions
		   end
	
      directions.each do |dir|
	each_adjacent_space_for_direction(space,dir,offset) { |s| yield s }
      end
    end
  end
end
