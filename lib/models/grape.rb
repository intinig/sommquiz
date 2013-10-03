require 'data_mapper'

class Grape
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :length => 255, :index => true

  has n, :wines, :through => Resource
  has n, :regions, :through => :wines
end
