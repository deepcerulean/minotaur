require 'benchmark'
module Minotaur
  module Pathfinders
    module DijkstrasPathfinder
      attr_accessor :solution_path

      def path(start, destination)
	# puts "--- finding path between #{start} and #{destination}"
	# puts Benchmark.measure { }
	find_path(start, destination) 
	@solution_path
      end

      def find_path(start, destination)
	@distance = {}
	@previous = {}
	@visited = []
	@unvisited = [] # all_positions

	each_position do |position|
	  if accessible?(position)
	    @unvisited << position
	    @distance[position] = 1.0/0.0 #Infinity
	    @previous[position] = nil
	  end
	end

	@distance[start] = 0
	done = false
	
	until done || @unvisited.count == 0
	  @current = @unvisited.min_by { |u| @distance[u] }
	  @unvisited -= [@current]
	  each_passable_adjacent_to(@current) do |node|
	    current_distance  = @distance[@current]
	    next_distance     = @distance[node]
	    adjusted_distance = current_distance + 1 # default distance between nodes = 1
	    if adjusted_distance < next_distance
	      @distance[node] = adjusted_distance
	      @previous[node] = @current
	    end
	  end
	  @visited << @current
	  done = true if @current == destination # @visited.include?(destination)
	end

	# assemble solution path
	solution_path = []
	node = destination
	while @previous[node]
	  solution_path.push(node)
	  node = @previous[node]
	end
	solution_path.push(start)
	@solution_path = solution_path.reverse
      end
    end
  end
end
