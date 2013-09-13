class WineSource
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :link, String

  belongs_to :region
  belongs_to :denomination

  has 1, :wine

  def self.doc(params = {})
    all(params.merge(:denomination => "DOC"))
  end

  def self.docg(params = {})
    all(params.merge(:denomination => "DOCG"))
  end
end
