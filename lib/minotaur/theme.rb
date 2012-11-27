module Minotaur
  #
  #   supporting logic for 'pluggable' generator-sets
  #
  class Theme
    def self.current_theme
      @@current_theme ||= DEFAULT_THEME
    end

    def self.generate(sym,opts={},&blk)
      @@feature_generators[sym].call(opts, &blk)
    end

    class << self
      def feature_generators
        @@feature_generators ||= {}
      end

      def feature_names
        feature_generators.keys
      end

      def method_missing(method_name, *args, &block)
        feature_generators[method_name] = block
      end
    end
  end
end