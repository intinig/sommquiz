require 'data_mapper'

class Region
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :index => true

  has n, :wines

  has n, :denominations, :through => :wines
  has n, :grapes, :through => :wines
end
