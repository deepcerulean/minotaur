module Minotaur
  class Size < Struct.new(:width, :height)
    def area
      width * height
    end

    def to_s
      "#{self.width}x#{self.height}"
    end
  end
end