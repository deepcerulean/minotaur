# module Minotaur
#   class Entity
#     attr_accessor :name
#     attr_accessor :location
#     attr_accessor :features
# 
#     def initialize(opts={})
#       self.name = opts.delete(:name) 	     { 'unnamed entity' }
#       self.location = opts.delete(:location) { origin }
#       self.features = opts.delete(:features) { OpenStruct.new }
#     end
#   end
# end
