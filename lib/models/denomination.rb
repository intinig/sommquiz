require 'data_mapper'
require 'active_support/deprecation'

class Denomination
  include DataMapper::Resource
  include SommQuiz::RedisPersistence

  property :id, Serial
  property :name, String, :index => true

  has n, :wines

  has n, :regions, :through => :wines
end
