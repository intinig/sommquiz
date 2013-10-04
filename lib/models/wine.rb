require 'data_mapper'

class Wine
  include DataMapper::Resource
  include SommQuiz::RedisPersistence

  property :id, Serial
  property :name, String, :length => 255, :index => true
  property :link, String, :length => 255
  property :grapes_description, Text

  belongs_to :region
  belongs_to :denomination

  has n, :grapes, :through => Resource

  def self.seed_wines
    ActiveSupport::Deprecation.silence do
      Wine.all.each do |wine|
        REDIS.sadd "denomination:all:wines", wine.name
        REDIS.sadd "denomination:#{wine.denomination.name}:wines", wine.name
        REDIS.set "wine:#{wine.name}:denomination", wine.denomination.name

        REDIS.sadd "region:#{wine.region.name}:all:wines", wine.name
        REDIS.sadd "region:#{wine.region.name}:#{wine.denomination.name}:wines", wine.name
        REDIS.sadd "denomination:#{wine.denomination.name}:regions", wine.region.name
        REDIS.sadd "denomination:all:regions", wine.region.name
        REDIS.set "wine:#{wine.name}:region", wine.region.name

        Region.all(:id.not => wine.region.id).each do |region|
          REDIS.sadd "region:#{region.name}:all:wines:outside", wine.name
          REDIS.sadd "region:#{region.name}:#{wine.denomination.name}:wines:outside", wine.name
        end

        wine.grapes.map{|g| g.name.downcase}.each do |grape|
          if wine.name =~ /#{grape}/i
            REDIS.sadd "wines:with_grapes:all", wine.name
            REDIS.sadd "wines:with_grapes:#{wine.denomination.name}", wine.name
          end

          REDIS.sadd "wine:#{wine.name}:grapes", grape.capitalize
          REDIS.sadd "region:#{wine.region.name}:grapes", grape.capitalize
          REDIS.sadd "grape:#{grape}:wines", wine.name
          REDIS.sadd "grape:#{grape}:regions", wine.region.name
          REDIS.sadd "denomination:#{wine.denomination.name}:grapes", grape.capitalize
          REDIS.sadd "denomination:all:grapes", grape.capitalize
          REDIS.sadd "grape:#{grape}:denominations", wine.denomination.name
        end
      end
    end
  end

  def self.count_with_grapes(denomination = "DOCG")
    REDIS.scard "wines:with_grapes:#{denomination}"
  end

  def self.sample_outside_region(region, qty = 1, denomination = "DOCG")
    REDIS.srandmember "region:#{region}:#{denomination}:wines:outside", qty
  end

  def self.sample_regional_wines(region, qty = 1, denomination = "DOCG")
    REDIS.srandmember "region:#{region}:#{denomination}:wines", qty
  end

  def self.get_all(denomination = "DOCG")
    REDIS.smembers "denomination:#{denomination}:wines"
  end

  def self.get_region(wine)
    REDIS.get "wine:#{wine}:region"
  end

  def self.exists?(wine, denomination = "DOCG")
    REDIS.sismember("denomination:#{denomination}:wines", wine)
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


  def has_grapes_in_name?
    REDIS.sismember "wines:with_grapes:all", name
  end
end
