require 'data_mapper'

class Wine
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :length => 255
  property :link, String, :length => 255
  property :grapes_description, Text

  belongs_to :region
  belongs_to :denomination

  has n, :grapes, :through => Resource

  def self.doc(params = {})
    Denomination.first(:name => "DOC").wines.all(params)
  end

  def self.docg(params = {})
    Denomination.first(:name => "DOCG").wines.all(params)
  end

  def stripped_name
    name.gsub(denomination.name, "").strip
  end

  def structured_grapes
    repository.adapter.select("select a.id as wid, b.id as gid, a.name, b.name from wines a join grapes b on a.grapes_description like '%' || b.name || '%' where a.id = ?", id)
  end

  def split_grapes
    structured_grapes.map{|g| g.name}
  end
end
