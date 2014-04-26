module Minotaur
  #
  # most structural classes are going to descend from this eventually
  # we'll bake-in extensible 'features' or options to all entities
  # for later theming, flexible extension
  #
  class Entity
    extend Forwardable
    def initialize(options = {})
      @options = OpenStruct.new(options)
      self.class.instance_eval do
	def_delegators :@options, *options.keys
      end
    end

    # ??
    def features; @options end

    def method_missing(sym, *args, &block)
      features.send sym, *args, &block
    end
  end
end
