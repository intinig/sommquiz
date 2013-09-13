class Wine
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :grapes, Text

  belongs_to :region
  belongs_to :denomination
  belongs_to :wine_source
end
