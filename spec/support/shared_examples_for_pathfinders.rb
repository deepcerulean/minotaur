SIZE = 6

shared_examples_for "a pathfinder" do
  before(:all) do
    @labyrinth = Minotaur::Labyrinth.new(width: SIZE, height: SIZE, pathfinder: subject)
    @labyrinth.extrude!
  end

  it "explores a #{SIZE}x#{SIZE} labyrinth to identify shortest route(s)" do
    Minotaur::Geometry::Grid.each_position(SIZE,SIZE) do |src|
      Minotaur::Geometry::Grid.each_position(SIZE,SIZE) do |dst|
        if src != dst
          @labyrinth.path_between?(dst,src).should be_true
          puts @labyrinth.to_s(@labyrinth.solution_path)
        end
      end
    end
  end
end