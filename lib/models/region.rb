require 'data_mapper'

class Region
  include DataMapper::Resource
  include SommQuiz::RedisPersistence

  property :id, Serial
  property :name, String, :index => true

  has n, :wines

  has n, :denominations, :through => :wines
  has n, :grapes, :through => :wines


  def self.seed_regions
    REDIS.sadd "regions", ["Abruzzo", "Valle d'Aosta", "Piemonte", "Liguria", "Lombardia", "Veneto", "Trentino Alto Adige", "Friuli Venezia Giulia", "Emilia Romagna", "Toscana", "Marche", "Umbria", "Lazio", "Campania", "Puglia", "Molise", "Basilicata", "Sicilia", "Sardegna", "Calabria"]
  end

  def self.get_random(exclude = [])
    regions = REDIS.smembers "regions"
    regions.select {|r| !(exclude.include?(r))}.sample
  end

  def self.get_count
    REDIS.scard "regions"
  end

  def self.get_all
    REDIS.smembers "regions"
  end

  def self.sample(qty = 1)
    REDIS.srandmember "regions", qty
  end
end
