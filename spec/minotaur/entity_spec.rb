require 'spec_helper'

describe Minotaur::Entity do
  it 'should create attributes from hash options' do
    entity = Minotaur::Entity.new foo: 'bar'
    entity.foo.should eql 'bar'
  end

  it 'should create attributes on-the-fly' do
    entity = Minotaur::Entity.new
    entity.foo = 'bar'
    entity.foo.should eql 'bar'
  end
end
