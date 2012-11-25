module Minotaur
  module Extruders
    module RoomExtruder
      attr_accessor :rooms, :doors
      attr_accessor :start, :min_edge_length, :variance

      def extrude!(opts={})
        self.start            = opts.delete(:start)            { origin }
        self.min_edge_length  = opts.delete(:min_edge_length)  { 5 }
        self.variance         = opts.delete(:variance)         { 0 }

        self.rooms = opts.delete(:rooms) { subdivider.subdivide(root) }

        #p rooms

        #raise "halt!"

        carve_rooms!
        # carve_passages! # if rooms aren't adjoining...
        carve_doorways!
      end

      def subdivider
        @subdivider ||= Geometry::Subdivider.new(min_edge_length: min_edge_length, variance: variance)
      end

      def rooms
        @rooms ||= []
      end

      def doors
        @doors ||= []
      end

      def root
        @root ||= Room.new(location: start, width: width, height: height)
      end

      def carve_rooms!
        rooms.each do |room|
          #puts "--- carving room: #{room}"
          room.carve!(self)
        end
      end

      def each_adjoining_room_pair
        @already_yielded = []
        rooms.each do |room|
          rooms.each do |other_room|
            unless (room == other_room)
              pair = [room,other_room]
              if !@already_yielded.include?(pair) && room.adjoining?(other_room)
                yield pair
                @already_yielded << [room,other_room]
                @already_yielded << [other_room,room]
              end
            end
          end
        end
      end

      def carve_doorways!
        each_adjoining_room_pair do |room,other_room|
          carve_doorway!(room,other_room)
        end
      end

      def carve_doorway!(room,other_room)
        shared_edge = room.adjoining_edge(other_room)
        a,b = shared_edge.sort_by { rand }.first
        start,finish = Position.new(a[0],a[1]), Position.new(b[0],b[1])
        build_passage!(start,finish)
      end
    end
  end
end