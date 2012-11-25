module Minotaur
  module Extruders
    #
    #  contains plug-in functionality for labyrinth to extrude rooms and doorways
    #
    module RoomExtruder
      attr_accessor :rooms, :doors
      attr_accessor :start, :min_edge_length, :variance

      def extrude!(opts={})
        self.start            = opts.delete(:start)            { origin }
        self.min_edge_length  = opts.delete(:min_edge_length)  { 5 }
        self.variance         = opts.delete(:variance)         { 0 }
        self.rooms            = opts.delete(:rooms) { subdivider.subdivide(root) }

        carve_rooms! and carve_doorways!
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
          room.carve!(self)
        end
      end

      def each_room_pair
        rooms.each do |room_one|
          rooms.each do |room_two|
            yield [room_one,room_two] unless (room_one == room_two)
          end
        end
      end

      def each_adjoining_room_pair
        @already_yielded = []
        each_room_pair do |room, other_room|
          if !@already_yielded.include?([room,other_room]) && room.adjoining?(other_room)
            yield [room,other_room]
            @already_yielded << [room,other_room]
            @already_yielded << [other_room,room]
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
        alpha,beta = shared_edge.sort_by { rand }.first
        start,finish = Position.new(alpha[0],alpha[1]), Position.new(beta[0],beta[1])
        build_passage!(start,finish)

        # TODO custom door class...
        doors << [room,other_room]
      end
    end
  end
end