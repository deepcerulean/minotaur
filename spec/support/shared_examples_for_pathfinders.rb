shared_examples_for "a pathfinder" do
  let(:size)  { 3 }

  let(:labyrinth) do
    Minotaur::Labyrinth.new(size: size, pathfinder: subject)
  end

  context "explores a domain to identify shortest route(s)" do
    let(:origin) { Minotaur::Position.origin }
    describe "in the case where the origin and destination are the same" do
      let(:destination) { origin }

      it "should have found a route" do
        labyrinth.path_between?(origin,destination).should be_true
      end

      it "should give back the destination as the route" do
        labyrinth.path_between?(origin,destination).should be_true
        labyrinth.solution_path.should_not be_nil
        labyrinth.solution_path.should eql([origin])
      end
    end

    describe "in a normal case" do
      let(:destination) { Minotaur::Position.new(3,3) }
      let(:size)        { 4 }

      before(:each) do
        labyrinth.carve_passages!
      end

      it "should have found a route" do
        labyrinth.path_between?(origin,destination).should be_true
      end

      it "should have an awesome shortest route" do
        labyrinth.path_between?(origin,destination).should be_true
        labyrinth.solution_path.should_not be_nil
      end
    end
  end
end