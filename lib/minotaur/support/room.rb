module Minotaur
  #
  #  room object -- really purely structural, but implementing a method of breaking down a
  #                 room into smaller rooms (maybe connected?)
  #
  class Room < Struct.new(:location,:width,:height)
    def to_s
      "#{width}x#{height} room at #{location}"
    end

    def coinflip?; rand > 0.5 end

    def split!(opts={}) # n=2, min=3, recursive=true,depth=0)
      n          = opts.delete(:count)      { 3 }
      min_area   = opts.delete(:min_area)   { 10 }
      recursive  = opts.delete(:recursive) { true }
      depth      = opts.delete(:depth) { 0 }

      direction  = opts.delete(:direction) do
        #if width <= min_*n && height >= min*n
        #  'vertical'
        #elsif height <= min*n && width >= min*n
        #  'horizontal'
        #else
          coinflip? ? 'horizontal' : 'vertical'
        end
      #end
      puts "-- area #{self.width * self.height} (width: #{self.width}, height: #{self.height})"
      puts "--- min area #{min_area}"

      return [self] if ((self.width * self.height) <= min_area**2)  #|| depth > 15 #.to_f/n <= min && self.height.to_f/n <= min)

      puts "=== split!'ing #{direction}ly #{n} times with min area #{min_area} (current depth #{depth})"

      resultant_rooms = []
      if direction == 'horizontal'
        total_width = 0
        Scalar.new(self.width).split!(n,Math.sqrt(min_area)).each_with_index do |next_width,_|
          resultant_rooms << Room.new(location.translate(EAST,total_width),next_width,height)
          total_width = total_width + next_width
        end
      elsif direction == 'vertical'
        total_height = 0
        Scalar.new(self.height).split!(n,Math.sqrt(min_area)).each_with_index do |next_height,_|
          resultant_rooms << Room.new(location.translate(SOUTH,total_height),width,next_height)
          total_height = total_height + next_height
        end
      else
        raise "Unknown direction: #{direction}"
      end

      if recursive
        rooms_after_recurse = []
        resultant_rooms.each do |room|
          smaller_rooms = room.split!(count: n, min_area: min_area, recursive: true, depth: depth+1).flatten
          rooms_after_recurse << smaller_rooms
        end

        unless rooms_after_recurse.empty?
          resultant_rooms = rooms_after_recurse.flatten
        end
      end

      puts "--- resultant rooms: "
      resultant_rooms.each { |r| puts "- #{r}" }

      resultant_rooms.flatten
    end
  end

end