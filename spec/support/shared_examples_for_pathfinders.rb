SIZE = 4

shared_examples_for "a pathfinder" do
  before(:all) do
    @labyrinth = Minotaur::Labyrinth.new(size: SIZE, pathfinder: subject)
    @labyrinth.extrude!
  end

  it "explores a #{SIZE}x#{SIZE} labyrinth to identify shortest route(s)" do
    Minotaur::Grid.each_position(SIZE,SIZE) do |src|
      Minotaur::Grid.each_position(SIZE,SIZE) do |dst|
        if src != dst
          @labyrinth.path_between?(dst,src).should be_true
        end
      end
    end
  end
end