module Minotaur
  module Features
    # base class for features (even needed?)
    class Feature
      #attr_accessor :kinds
      def self.kinds
        @@kinds ||= []
      end

      def self.inherited(cls)
        kinds << cls.name.split('::').last.underscore #downcase
        #p kinds
      end
      # < OpenStruct.new # < Struct.new(:name, :description)
      # ...
      # attr_accessor :name, :description

      #  def self.generate_suite!(space)
      #
      #  end
    end
  end
end