require 'spec_helper'
require_relative '../../../lib/minotaur/explorer/game' # File.join(File.dirname(__FILE__), '/../../lib/explorer/game')

describe Minotaur::Explorer::Game do
  its(:dungeon) { should_not be_nil }

  context 'playing a game' do 
    its(:player_name) { should be_a(String) }
  end
end

##TODO write specs for this
##need command line spec helpers -- or a better design... :/
#require 'spec_helper'
#
##require 'lib/minotaur/explorer/explorer'
#
#describe Minotaur::Explorer::Explorer
#  subject { Minotaur::Explorer::Explorer.new }
#  #it "should load without issue" do
#  #  subject.should be_awesome
#  #end
#end
