module Minotaur
  #
  #  room object -- really purely structural, but implementing a method of breaking down a
  #                 room into smaller rooms (maybe connected?)
  #
  class Room < Struct.new(:location,:width,:height)
    include FateHelpers

    def ==(other)
      self.x == other.x && self.y == other.y && self.width == other.width && self.height == other.width
    end

    def to_s
      "#{width}x#{height} room at #{location}"
    end

    def x; location.x end
    def y; location.y end
    def area; width * height end


    # yay demorgan!
    # basically we check two things for two sides
    #  (1) whether one coordinate is actually 'abutting' the other
    #  (2) if so, whether the edges (the other coordinate) actually overlap
    # and then invert (just once) for the remainder, since it's a reflection.

    # need a better name for this
    # basically: what is the direction between this room and the other room, IFF they are adjacent?

    def adjacent_direction(other,inverse=false)
      if other.x == self.x+self.width #+1
        if (((self.y <= other.y+other.height) && (self.y+self.height >= other.y)) ||
            ((other.y <= self.y+self.height) && (other.y+other.height >= self.y)))
          return EAST
        end
      elsif other.y == self.y+self.height #+1
        if (((self.x <= other.x+other.width) && (self.x+self.width >= other.x)) ||
            ((other.x <= self.x+self.width) && (other.x+other.width >= self.x)))
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
      edge = case adjacent_direction(other_room)
        when SOUTH then  ([other_room.x,self.x].min...[self.x+self.width,other_room.x+other_room.width].max).map { |next_x|
          [[next_x,other_room.y-1],[next_x,other_room.y]]
        }
        when EAST then  ([other_room.y,self.y].min...[self.y+self.height,other_room.y+other_room.height].max).map { |next_y|
          [[other_room.x-1,next_y],[other_room.x,next_y]]
        }
        else
          inverse ? nil : other_room.shared_edge(self,true)
      end
      return edge
    end


    MAX_DEPTH = 25
    def split!(opts={})
      n                  = opts.delete(:count)            { 2 }
      min_edge_length    = opts.delete(:min_edge_length)  { 5 }
      recursive          = opts.delete(:recursive)        { true }
      variance           = opts.delete(:variance)         { 0 }
      depth              = opts.delete(:depth)            { 0 }

      reached_size_limit = (width < min_edge_length || height < min_edge_length)

      return [self] if reached_size_limit || (recursive && depth > MAX_DEPTH)

      direction  = opts.delete(:direction) { favorable_split_direction(min_edge_length) }

      resultant_rooms = split(n,min_edge_length,direction,variance)

      if recursive
        rooms_after_recurse = []
        resultant_rooms.each do |room|
          smaller_rooms = room.split!(count: n, min_edge_length: min_edge_length, variance: variance, recursive: true, depth: depth+1).flatten
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

    def split(n=2,min_edge_length=2,direction=favorable_split_direction(2),variance=0)
      resultant_rooms = []
      if direction == 'horizontal'
        total_width = 0
        Scalar.new(width).split!(count: n, minimum: min_edge_length, variance: variance).each do |next_width|
          resultant_rooms << Room.new(location.translate(EAST,total_width),next_width,height)
          total_width = total_width + next_width
        end
      elsif direction == 'vertical'
        total_height = 0
        Scalar.new(height).split!(count: n, minimum: min_edge_length, variance: variance).each do |next_height|
          resultant_rooms << Room.new(location.translate(SOUTH,total_height),width,next_height)
          total_height = total_height + next_height
        end
      else
        raise "Unknown direction: #{direction}"
      end
      resultant_rooms
    end


  end

end