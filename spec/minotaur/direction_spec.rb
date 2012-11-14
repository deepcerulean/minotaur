require "rspec"

require "minotaur"

include Minotaur

describe Direction do
  {
    EAST => WEST,
    WEST =>  EAST,
    NORTH =>  SOUTH,
    SOUTH => NORTH
  }.each do |direction,opposite|
    it "should give #{Direction.humanize(direction)} as opposite of #{Direction.humanize(opposite)}" do
      Direction.opposite(direction).should be(opposite)
    end
  end
end