module Minotaur
  module Features
    # base class for features
    class Feature < Struct.new(:name, :description)
      # ...
    end
  end
end