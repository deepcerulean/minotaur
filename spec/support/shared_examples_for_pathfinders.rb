require 'pry'
shared_examples_for "a pathfinder" do
  before(:all) do
    @labyrinth = Minotaur::Labyrinth.new(width: 5, 
					 height: 5, 
					 extruder: Minotaur::Extruders::OpenSpaceExtruder,
					 prettifier: Minotaur::Prettifiers::SimplePrettifier, 
					 pathfinder: subject)
    @labyrinth.extrude!
  end
  
  # not necessarily shortest!
  it 'should find a simple path' do
    source = Minotaur::Geometry::Position.new(0,0)
    target = Minotaur::Geometry::Position.new(4,4)
    
    path = @labyrinth.path(source, target)
    path.first.should eql(source)
    path.last.should  eql(target)

    # if we want to enforce shortest path (disqualifies recursive backtracking...)
    # path.size.should eql(9) 
    # binding.pry
  end

  # it "explores a #{SIZE}x#{SIZE} labyrinth to identify shortest route(s)" do
  #   Minotaur::Geometry::Grid.new(width: SIZE, height: SIZE).each_position do |src|
  #     Minotaur::Geometry::Grid.new(width: SIZE, height: SIZE).each_position do |dst|
  #     # Minotaur::Geometry::Grid.each_position(SIZE,SIZE) do |dst|
  #       if src != dst
  #         @labyrinth.path(dst,src).should be_true
  #         puts @labyrinth.to_s(@labyrinth.solution_path)
  #         # puts @labyrinth.solution_path
  #       end
  #     end
  #   end
  # end
end
