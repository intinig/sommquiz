require 'data_mapper'

class Grape
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :length => 255

  has n, :wines, :through => Resource
end
