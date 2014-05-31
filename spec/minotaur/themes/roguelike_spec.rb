require 'spec_helper'

include Minotaur::Themes
include Minotaur::Support::ThemeHelpers
describe Roguelike do
  let(:room) { generate :room }
  
  context '#treasure' do
    let(:treasure) { room.entities.detect { |e| e.type == :gold }}
    it 'should generate gold pieces' do
      treasure.should_not be_nil
      treasure.amount.should be >= 1
    end
  end
end
