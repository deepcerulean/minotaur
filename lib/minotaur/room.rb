module Minotaur
  #
  #  room object -- really purely structural, but implementing a method of breaking down a
  #                 room into smaller rooms (maybe connected?)
  #
  #  throughout this whole class is methods with eerily similar logic depending on whether
  #  horizontal or vertical -- south or east -- is intended...
  #
  # TODO simplify further! -- maybe need a 'space' class with the subdivision-handling strategies
  #
  class Room < Space
    #Struct.new(:location,:width,:height)
    #include FateHelpers
    #include ScalarHelpers

    #attr_accessor :features
    #
    #def to_s
    #  "#{width}x#{height} room at #{location}"
    #end
    #
    #def x
    #  location.x
    #end
    #
    #def y
    #  location.y
    #end
    #
    #def area
    #  width * height
    #end

    #def adjoining_direction(other,inverse=false)
    #  if other.x == self.x+self.width-1 #+1
    #    if range_overlap?( (y..y+height), (other.y..other.y+other.height-1) )
    #      return EAST
    #    end
    #  elsif other.y == self.y+self.height-1 #+1
    #    if range_overlap?( (x..x+width), (other.x..other.x+other.width-1) )
    #      return SOUTH
    #    end
    #  end
    #
    #  # we're exhausted if we were called by ourselves
    #  return nil if inverse
    #
    #  direction_opposite(other.adjoining_direction(self,true))
    #end
    #
    #
    #def adjoining?(other_room)
    #  !adjoining_direction(other_room).nil?
    #end
    #
    #def adjoining_edge(other,inverse=false)
    #  direction = adjoining_direction(other)
    #  if direction == SOUTH
    #    range = range_overlap(self.x...self.x+width-1, other.x...other.x+other.width-1)
    #    range.map { |next_x| [[next_x,other.y-1],[next_x,other.y]] }
    #  elsif direction == EAST
    #    range = range_overlap(self.y...self.y+height-1, other.y...other.y+other.height-1)
    #    range.map { |next_y| [[other.x-1,next_y],[other.x,next_y]] }
    #  else
    #    inverse ? nil : other.adjoining_edge(self,true)
    #  end
    #end
    #
    #MAX_DEPTH = 25
    #def subdivide!(opts={})
    #  n                  = opts.delete(:count)            { 2 }
    #  min_edge_length    = opts.delete(:min_edge_length)  { 5 }
    #  recursive          = opts.delete(:recursive)        { true }
    #  variance           = opts.delete(:variance)         { 0 }
    #  depth              = opts.delete(:depth)            { 0 }
    #
    #  reached_size_limit = (width < min_edge_length || height < min_edge_length)
    #  return [self] if reached_size_limit || (recursive && depth > MAX_DEPTH)
    #
    #  puts "--- Attempting to subdivide room with min edge length: #{min_edge_length}"
    #
    #  direction  = opts.delete(:direction) do
    #    favorable_split_direction(min_edge_length)
    #  end
    #  #n = 1
    #  resultant_rooms = if direction == 'horizontal'
    #    horizontal_subdivide(n,min_edge_length,variance)
    #  elsif direction == 'vertical'
    #    vertical_subdivide(n,min_edge_length,variance)
    #  end
    #
    #  if recursive
    #    Room.subdivide!(resultant_rooms, {
    #      count: count,
    #      min_edge_length: min_edge_length,
    #      variance: variance,
    #      depth: depth
    #    })
    #  end
    #
    #  resultant_rooms.flatten
    #end
    #
    ##
    ## class method to subdivide a list of rooms -- used by Room#subdivide!
    ## to call itself in the recursive case
    ##
    #def self.subdivide!(rooms=[],opts={})
    #  min_edge_length = opts.delete(:min_edge_length) { 5 }
    #  variance        = opts.delete(:variance)        { 0 }
    #  depth           = opts.delete(:depth)           { 0 }
    #  count           = opts.delete(:count)           { 2 }
    #
    #  resultant_rooms = rooms
    #  rooms_after_subdivide = []
    #
    #  rooms.each do |room|
    #    smaller_rooms = room.subdivide!({
    #      count: count,
    #      min_edge_length: min_edge_length,
    #      variance: variance,
    #      recursive: true,
    #      depth: depth+1
    #    })
    #    rooms_after_subdivide << smaller_rooms
    #  end
    #
    #  unless rooms_after_subdivide.empty?
    #    resultant_rooms = rooms_after_subdivide
    #  end
    #
    #  resultant_rooms
    #end
    #
    #private
    #
    #def favorable_split_direction(min_edge_length)
    #  if width < min_edge_length
    #    'horizontal'
    #  elsif height < min_edge_length
    #    'vertical'
    #  else
    #    coinflip? ? 'horizontal' : 'vertical'
    #  end
    #end
    #
    #def vertical_subdivide(opts={}) # n=2,min_edge_length=2,variance=0)
    #  resultant_rooms = []
    #  total_width = 0
    #  split!(width, count: n, min_subdivision_length: min_edge_length, variance: variance).each do |next_width|
    #    resultant_rooms << Room.new(location.translate(EAST,total_width),next_width,height)
    #    total_width = total_width + next_width
    #  end
    #  resultant_rooms
    #end
    #
    #def horizontal_subdivide(opts={}) #n=2,min_edge_length=2,variance=0)
    #  resultant_rooms = []
    #  total_height = 0
    #  split_and_mutate!(height, count: n, min_subdivision_length: min_edge_length, variance: variance).each do |next_height|
    #    resultant_rooms << Room.new(location.translate(SOUTH,total_height),width,next_height)
    #    total_height = total_height + next_height
    #  end
    #  resultant_rooms
    #end
  end
end