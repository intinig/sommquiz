class Wine
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :length => 255
  property :link, String, :length => 255
  property :grapes, Text

  belongs_to :region
  belongs_to :denomination

  def self.doc(params = {})
    Denomination.first(:name => "DOC").wines.all(params)
  end

  def self.docg(params = {})
    Denomination.first(:name => "DOCG").wines.all(params)
  end

  def stripped_name
    name.gsub(denomination.name, "").strip
  end
end
