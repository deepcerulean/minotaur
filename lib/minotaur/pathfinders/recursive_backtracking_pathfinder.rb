module Minotaur
  module Pathfinders
    class RecursiveBacktrackingPathfinder

      def path_between(labyrinth,origin,destination) #,path=[])
        puts "--- Attempting to find distance between origin #{origin} and destination #{destination} for labyrinth"
        puts labyrinth
        path = []
        return path if origin==destination

        routes = labyrinth.each_open(origin).map do |next_pos|
          path_between(labyrinth,next_pos,destination)
        end

        #shortest_route = routes.min(:size) # do { |r| r.size } |next_position, direction|
        #end
        #path << path_between(labyrinth,next_position)

        path << routes.min(:size)

        path
      end

        #def explore!(labyrinth,target,origin=Position.origin,distance=0)
      #  return if target == origin
      #  labyrinth.each_open_with_direction(origin) do |next_position, direction|
      #    labyrinth.mark!(origin, direction)
      #    labyrinth.mark!(next_position, Direction.opposite(direction))
      #    intrude!(labyrinth,target,next_position,distance+1)
      #  end
      #end


    end
  end
end