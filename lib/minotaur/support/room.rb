module Minotaur
  #
  #  room object -- really purely structural, but implementing a method of breaking down a
  #                 room into smaller rooms (maybe connected?)
  #
  class Room < Struct.new(:location,:width,:height)
    include FateHelpers
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
    # and then invert once for the remainder, since it's a reflection.
    def adjacent?(other_room,inverse=false)
      #puts "--- trying to figure out if #{self} is adjacent to #{other_room}"
      if other_room.x == self.x+self.width+1
        if (self.y <= other_room.y+other_room.height) && (self.y+self.height >= other_room.y)
          return true
        end
      elsif other_room.y == self.y+self.height+1
        if (self.x <= other_room.x+other_room.width) && (self.x+self.width >= other_room.x)
          return true
        end
      end

      # we're exhausted if we were called by ourselves
      return false if inverse

      other_room.adjacent?(self,true)
    end

#        -----
    #####-----
    #   #-----
    #####

    #
    #  TODO break this monster into pieces somehow
    #       perhaps the core logic about recursively breaking a space
    #       can be made much more compact? (n.b., it's pretty much only that now...?)
    #
    MAX_DEPTH = 25
    def split!(opts={}) # n=2, min=3, recursive=true,depth=0)
      n                  = opts.delete(:count)            { 2 }
      min_edge_length    = opts.delete(:min_edge_length)  { 5 }
      recursive          = opts.delete(:recursive)        { true }
      variance           = opts.delete(:variance)         { 0 }
      depth              = opts.delete(:depth)            { 0 }

      #min_area               = min_edge_length**2 # opts.delete(:min_area)   { 15 }
      min_parent_edge_length = min_edge_length*n
      #min_parent_area        = min_parent_edge_length**2

      reached_size_limit = #(area < min_parent_area) #||
          (width < min_edge_length || height < min_edge_length)

      return [self] if reached_size_limit || (recursive && depth > MAX_DEPTH)


      direction  = opts.delete(:direction) do
        if width < min_edge_length
          'horizontal'
        elsif height < min_edge_length
          'vertical'
        else
          coinflip? ? 'horizontal' : 'vertical'
        end
      end

      resultant_rooms = []

      if direction == 'horizontal'
        total_width = 0
        Scalar.new(self.width).split!(count: n, minimum: min_edge_length, variance: variance).each do |next_width|
          resultant_rooms << Room.new(location.translate(EAST,total_width),next_width,height)
          total_width = total_width + next_width
        end
      elsif direction == 'vertical'
        total_height = 0
        Scalar.new(self.height).split!(count: n, minimum: min_edge_length, variance: variance).each do |next_height|
          resultant_rooms << Room.new(location.translate(SOUTH,total_height),width,next_height)
          total_height = total_height + next_height
        end
      else
        raise "Unknown direction: #{direction}"
      end

      if recursive # && !reached_size_limit
        rooms_after_recurse = []
        resultant_rooms.each do |room|
          smaller_rooms = room.split!(count: n, min_edge_length: min_edge_length, recursive: true, depth: depth+1).flatten
          rooms_after_recurse << smaller_rooms
        end

        unless rooms_after_recurse.empty?
          resultant_rooms = rooms_after_recurse.flatten
        end
      end

      resultant_rooms.flatten
    end
  end

end