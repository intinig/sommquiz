class Denomination
  include DataMapper::Resource

  property :id, Serial
  property :name, String

  has n, :wines

  has n, :regions, :through => :wines
end
