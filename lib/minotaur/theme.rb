module Minotaur
  #
  #   supporting logic for 'pluggable' generator-sets
  #
  class Theme
    def self.current_theme
      @@current_theme ||= DEFAULT_THEME
    end

    def self.generate(entity,opts={},&blk)
      generator = @@feature_generators[entity]
      generator.call(opts, &blk)
    end

    class << self
      def feature_generators
        @@feature_generators ||= {}
      end

      def feature_names
        feature_generators.keys
      end

      # def dungeon...

      #def room(room_name=nil,opts={}, &blk)
      #  if room_name
      #    feature_generators[:rooms][room_name.to_sym] = block
      #    # this is a particular room -- remember it
      #    # TODO expose a helper to build this room
      #  else
      #    feature_generators[:room] = block
      #  end
      #end

      def method_missing(method_name, *args, &block)
        feature_generators[method_name] = block
      end
    end
  end
end