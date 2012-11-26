module Minotaur
  module Features
    class RoomType < Feature
      attr_accessor :type
      def initialize(type) #, opts={})
        self.type = type
      end

      def to_s; type end
    end
  end
end