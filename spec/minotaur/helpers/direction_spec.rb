require "spec_helper"

include Minotaur
include Minotaur::Helpers
include Minotaur::Helpers::DirectionHelpers

include Minotaur::Geometry
include Minotaur::Geometry::Directions

describe DirectionHelpers do
  {
    EAST => WEST,
    WEST =>  EAST,
    NORTH =>  SOUTH,
    SOUTH => NORTH
  }.each do |direction,opposite|
    it "should give #{humanize_direction(direction)} as opposite of #{humanize_direction(opposite)}" do
      direction_opposite(direction).should be(opposite)
    end
  end

  it "should give adjacent positions" do

  end
end