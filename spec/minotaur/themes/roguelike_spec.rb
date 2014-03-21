require 'spec_helper'

include Minotaur::Themes
include Minotaur::Support::ThemeHelpers
describe Roguelike do
  let(:room) { generate :room }
  
  context '#treasure' do
    let(:treasure) { room.features.treasure }
    it 'should generate gold pieces' do
      treasure.gold.should_not be_nil
      treasure.gold.first.amount.should be >= 1
    end
  end
end
