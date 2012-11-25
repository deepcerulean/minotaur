module Minotaur
  module Extruders
    #
    #  contains plug-in functionality for labyrinth to extrude rooms and doorways
    #  algorithm is straightfoward -- just about subdividing a room (users the Geometry::Subdivider utility)
    #
    module AssemblingRoomExtruder
      include SubdividingRoomExtruder
      include Geometry

      attr_accessor :rooms, :doors
      attr_accessor :start, :min_edge_length, :variance

      def extrude!(opts={})
        self.start            = opts.delete(:start)            { origin }
        self.min_edge_length  = opts.delete(:min_edge_length)  { 5 }
        self.variance         = opts.delete(:variance)         { 0 }
        self.rooms            = opts.delete(:rooms)            #{ generate_rooms! } # subdivider.subdivide(root) }

        assemble_rooms!(self.rooms, self)

        carve_rooms! and carve_doorways!
      end

      def assemble_rooms!(current_rooms, subregion)
        raise 'not implemented yet!'
        #sorted
        #current.each do |room|
        #  # place room
        #end
      end


      #def generate_rooms!(opts={})
      #
      #end

    end
  end
end