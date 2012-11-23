module Minotaur
  class Scalar < Struct.new(:magnitude)
    def split!(opts={}) #n=rand(4),min=5,variance=10)
      # options
      n               = opts.delete(:count) { 3 }
      min             = opts.delete(:minimum) { 4 }
      variance        = opts.delete(:variance) { 0 }

      # approximate length that would 'evenly' divide the magnitude into n segments
      split_magnitude = (self.magnitude/n).to_i

      return [magnitude] if split_magnitude < min
      width_so_far = 0
      resultant_magnitudes = []
      n.times do |index|
        next_width = split_magnitude
        if index==n-1
          next_width = (magnitude - width_so_far)
        else
          next_width = next_width + (rand*variance).to_i # until next_width >= min && (magnitude-(width_so_far+next_width)) >= min
        end
        width_so_far = width_so_far + next_width
        resultant_magnitudes << next_width
      end
      resultant_magnitudes
    end
  end
end