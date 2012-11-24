module Minotaur
  #
  #  room object -- really purely structural, but implementing a method of breaking down a
  #                 room into smaller rooms (maybe connected?)
  #
  #  throughout this whole class is methods with eerily similar logic depending on whether
  #  horizontal or vertical -- south or east -- is intended...
  #
  class Room < Struct.new(:location,:width,:height)
    include FateHelpers
    include ScalarHelpers

    def to_s
      "#{width}x#{height} room at #{location}"
    end

    def x; location.x end
    def y; location.y end
    def area; width * height end

    def adjacent_direction(other,inverse=false)
      if other.x == self.x+self.width #+1
        if range_overlap?( (y..y+height), (other.y..other.y+other.height) )
          return EAST
        end
      elsif other.y == self.y+self.height #+1
        if range_overlap?( (x..x+width), (other.x..other.x+other.width) )
          return SOUTH
        end
      end

      # we're exhausted if we were called by ourselves
      return nil if inverse

      direction_opposite(other.adjacent_direction(self,true))
    end


    def adjacent?(other_room)
      !adjacent_direction(other_room).nil?
    end

    def shared_edge(other_room,inverse=false)
      direction = adjacent_direction(other_room)
      if direction == SOUTH
        min_x = [other_room.x,self.x].min
        max_x = [self.x+self.width,other_room.x+other_room.width].max
        (min_x...max_x).map do |next_x|
          [[next_x,other_room.y-1],[next_x,other_room.y]]
        end
      elsif direction == EAST
        min_y = [other_room.y,self.y].min
        max_y = [self.y+self.height,other_room.y+other_room.height].max
        (min_y...max_y).map do |next_y|
          [[other_room.x-1,next_y],[other_room.x,next_y]]
        end
      else
        inverse ? nil : other_room.shared_edge(self,true)
      end
    end


    MAX_DEPTH = 25
    def subdivide!(opts={})
      n                  = opts.delete(:count)            { 2 }
      min_edge_length    = opts.delete(:min_edge_length)  { 5 }
      recursive          = opts.delete(:recursive)        { true }
      variance           = opts.delete(:variance)         { 0 }
      depth              = opts.delete(:depth)            { 0 }

      reached_size_limit = (width < min_edge_length || height < min_edge_length)
      return [self] if reached_size_limit || (recursive && depth > MAX_DEPTH)

      direction  = opts.delete(:direction) do
        favorable_split_direction(min_edge_length)
      end

      resultant_rooms = subdivide(n,min_edge_length,direction,variance)

      if recursive
        rooms_after_recurse = []
        resultant_rooms.each do |room|
          smaller_rooms = room.subdivide!({
            count: n,
            min_edge_length: min_edge_length,
            variance: variance,
            recursive: true,
            depth: depth+1
          })
          rooms_after_recurse << smaller_rooms
        end
        unless rooms_after_recurse.empty?
          resultant_rooms = rooms_after_recurse.flatten
        end
      end
      resultant_rooms.flatten
    end

    private

    def favorable_split_direction(min_edge_length)
      if width < min_edge_length
        'horizontal'
      elsif height < min_edge_length
        'vertical'
      else
        coinflip? ? 'horizontal' : 'vertical'
      end
    end

    def subdivide(n=2,min_edge_length=2,direction=favorable_split_direction(2),variance=0)
      if direction == 'horizontal'
        vertical_subdivide(n,min_edge_length,variance)
      elsif direction == 'vertical'
        horizontal_subdivide(n,min_edge_length,variance)
      end
    end

    def vertical_subdivide(n=2,min_edge_length=2,variance=0)
      resultant_rooms = []
      total_width = 0
      split!(width, count: n, minimum: min_edge_length, variance: variance).each do |next_width|
        resultant_rooms << Room.new(location.translate(EAST,total_width),next_width,height)
        total_width = total_width + next_width
      end
      resultant_rooms
    end

    def horizontal_subdivide(n=2,min_edge_length=2,variance=0)
      resultant_rooms = []
      total_height = 0
      split!(height, count: n, minimum: min_edge_length, variance: variance).each do |next_height|
        resultant_rooms << Room.new(location.translate(SOUTH,total_height),width,next_height)
        total_height = total_height + next_height
      end
      resultant_rooms
    end
  end
end