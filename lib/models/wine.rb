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

  def self.random(n = 0, options = {})
    denominations = options[:denominations] || ["DOC", "DOCG"]
    easy_by_region = options[:easy_by_region]
    exclude_grape_wines = options[:exclude_grape_wines]
    excluded_ids = options[:excluded_ids]
    upper_grapes_limit = options[:upper_grapes_limit] || 6
    lower_grapes_limit = options[:lower_grapes_limit] || 0

    denominations = Denomination.all(:name => denominations)
    wines = all(:denomination => denominations, :id.not => excluded_ids)

    n = n > wines.count ? wines.count : n

    wines = wines.sample(n) if n > 0

    excluded_ids = wines.map {|w| w.id}

    unless easy_by_region
      wines.delete_if do |wine|
        wine.name =~ /#{wine.region.name}/i
      end
    end

    if exclude_grape_wines
      new_wines = wines.dup
      wines.each do |w|
        w.grapes.map{|g| g.name.downcase}.each do |grape|
          if w.name =~ /#{grape}/i
            new_wines.delete w
            break
          end
        end
      end
      wines = new_wines
    end


    if upper_grapes_limit != 0
      wines.delete_if do |wine|
        wine.grapes.size > upper_grapes_limit
      end
    end

    if lower_grapes_limit > 0
      wines.delete_if do |wine|
        wine.grapes.size < lower_grapes_limit
      end
    end

    if wines.size < n
      wines << random(n - wines.size, options.merge(:excluded_ids => excluded_ids))
    end

    wines.flatten
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
