# maybe should be own submodule? should be build-able on its own
# it's really *downstream*...

require 'chingu'
#
#module Explorer
#  def self.root
#    File.join(File.dirname(__FILE__), '../')
#  end
#end


require 'minotaur/explorer/player'
require 'minotaur/explorer/window'

include Gosu
Image.autoload_dirs << File.join(Minotaur.root, "data", "images")

