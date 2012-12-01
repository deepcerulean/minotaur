module Minotaur
  class Region #< Struct.new(:location, :size)
    attr_accessor :location, :size

    def initialize(opts={})
      self.location = opts.delete(:location) #{ origin }
      if opts.include?(:width) && opts.include?(:height)
        self.size     = Size.new(width: opts.delete(:width), height: opts.delete(:height))
      else
        self.size     = opts.delete(:size)     { unit }
        self.size     = Size.new(width: size, height: size) if self.size.is_a? Fixnum
      end
    end

    def to_s
      output = ""
      output << "#{size}"
      output << " at #{location}" if location
      output
    end

    def width
      size.width
    end

    def height
      size.height
    end

    def area
      size.area
    end

    def x
      location.x
    end

    def y
      location.y
    end

    def contains?(position)
      position.x >= 0 && position.y >= 0 && position.x < self.width && position.y < self.height
    end
  end
end