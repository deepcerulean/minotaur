module Minotaur
  module Geometry
    class Size #< Struct.new(:width, :height)
      attr_accessor :width, :height
      def initialize(opts={})
	self.width  = opts.delete(:width) { 1 }
	self.height = opts.delete(:height) { 1 }
      end

      def area
	width * height
      end

      def to_s
	"#{self.width}x#{self.height}"
      end
    end
  end
end
