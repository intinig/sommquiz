require 'data_mapper'

class Grape
  include DataMapper::Resource
  include SommQuiz::RedisPersistence

  property :id, Serial
  property :name, String, :length => 255, :index => true

  has n, :wines, :through => Resource
  has n, :regions, :through => :wines

  def self.sample_regional(region, qty = 1)
    REDIS.srandmember "region:#{region}:grapes", qty
  end

  def self.sample_not_in_region(region, qty = 1)
    REDIS.sdiff("denomination:all:grapes", "region:#{region}:grapes").sample(qty)
  end
end
