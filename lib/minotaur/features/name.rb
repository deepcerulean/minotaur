module Minotaur
  module Features
    #
    #  placeholder class JUST to keep track of a name for a singular entity
    #
    #  note: this in particular -- along with binary predicate features -- really indicate we need to be using a more flexible data structure
    #        i.e., OpenStruct...
    class Name < Feature
      attr_accessor :name

      def initialize(name)
        self.name = name
      end

      def to_s
        name
      end
    end
  end
end