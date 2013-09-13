class Denomination
  include DataMapper::Resource

  property :id, Serial
  property :name, String

  has n, :wine_sources
  has n, :wines

  has n, :regions, :through => :wine_sources
end
