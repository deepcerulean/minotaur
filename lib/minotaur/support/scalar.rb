module Minotaur

  module ScalarHelpers
    # TODO really pretty general...
    def range_overlap?(r1,r2)
      r1.include?(r2.begin) || r2.include?(r1.begin)
    end

  #  def split!
  #
  #
  #class Scalar < Struct.new(:magnitude)
    def split!(magnitude,opts={})
      n               = opts.delete(:count) { 3 }
      min             = opts.delete(:minimum) { 4 }
      variance        = opts.delete(:variance) { 0 }

      split_magnitude = (magnitude/n).to_i

      return [magnitude] if split_magnitude < min

      width_so_far = 0
      resultant_magnitudes = []
      n.times do |index|
        next_width = split_magnitude
        if index==n-1
          next_width = (magnitude - width_so_far)
        else
          base = next_width
          valid_result = false
          max_rounds = 25
          rounds = 0
          deviation = variance**2
          until valid_result  || rounds > max_rounds
            offset = (rand(deviation)-deviation/2).to_i
            next_width = base + offset  #
            rounds = rounds + 1
            valid_result = (next_width >= min && (magnitude-(width_so_far+min*(n-index))) >= min)
          end
          next_width = split_magnitude if rounds > max_rounds
        end

        width_so_far = width_so_far + next_width
        resultant_magnitudes << next_width
      end
      resultant_magnitudes
    end
  end
end