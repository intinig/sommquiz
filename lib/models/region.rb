require 'data_mapper'

class Region
  include DataMapper::Resource

  property :id, Serial
  property :name, String

  has n, :wines

  has n, :denominations, :through => :wines
end
