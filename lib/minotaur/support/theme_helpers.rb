module Minotaur
  module Support
    module ThemeHelpers
      def current_theme
        Theme.current_theme
      end

      def generate(entity,opts={})
        current_theme.generate(entity,opts)
      end
    end
  end
end