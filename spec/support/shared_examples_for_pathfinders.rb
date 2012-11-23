SIZE = 10

shared_examples_for "a pathfinder" do
  before(:all) do
    @labyrinth = Labyrinth.new(size: SIZE, pathfinder: subject)
    @labyrinth.extrude!
  end

  it "explores a #{SIZE}x#{SIZE} labyrinth to identify shortest route(s)" do
    Labyrinth.each_position(SIZE,SIZE) do |src|
      Labyrinth.each_position(SIZE,SIZE) do |dst|
        if src != dst
          @labyrinth.path_between?(dst,src).should be_true
          #puts @labyrinth.to_s(@labyrinth.solution_path)
        end
      end
    end
  end
end