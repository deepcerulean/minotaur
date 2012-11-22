module Minotaur
  class Scalar < Struct.new(:magnitude)
    def split!(n,min,variance=5)
      #puts "-- Scalar#split! called: mag=#{magnitude}, min=#{min}, n=#{n}"
      split_magnitude = (self.magnitude/n).to_i
      #puts "-- split magnitude: #{split_magnitude}"
      return [magnitude] if split_magnitude < min
      width_so_far = 0
      resultant_magnitudes = []
      n.times do |index|
        #puts "-- #{index}-th split"
        next_width = split_magnitude + rand(variance) #[width_so_far, split_magnitude + rand(2)].min #.to_i
        if index==n-1
          #puts "-- assigining remaining width"
          next_width = (magnitude - width_so_far)
        end
        width_so_far = width_so_far + next_width
        #puts "--- width this iteration: #{next_width}"
        resultant_magnitudes << next_width
      end
      resultant_magnitudes
    end
  end
end