module Minotaur

  class Theme
    include Features

    def self.current_theme
      @@current_theme ||= DEFAULT_THEME
    end

    def self.generate(sym,opts={},&blk)
      @@generators[sym].call(opts, &blk)
    end

    class << self
      Minotaur::Features::Feature.kinds.each do |kind|
        define_method(kind.to_sym) { |&blk| register_generator(kind.to_sym, &blk) }
      end

      private

      def register_generator(sym, &blk)
        @@generators ||= {}
        @@generators[sym] = blk
      end
    end
  end
end