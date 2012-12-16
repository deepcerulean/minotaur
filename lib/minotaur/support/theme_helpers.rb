module Minotaur
  module Support
    module ThemeHelpers
      def current_theme
        Theme.current_theme
      end

      def generate(entity,opts={})
        current_theme.generate(entity,opts)
      end

      #def generate_suite!(opts={})
      #  #features = []
      #  current_theme.feature_names.map do |feature|
      #    generate(feature.to_sym)
      #  end
      #  #features
      #end
    end
  end
end