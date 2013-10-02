require 'data_mapper'

class Denomination
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :index => true

  has n, :wines

  has n, :regions, :through => :wines
end
