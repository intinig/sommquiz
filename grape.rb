class Grape
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :length => 255
end
