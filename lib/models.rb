require 'data_mapper'
require 'redis'
require __dir__ + "/somm_quiz/redis_persistence"

MODELS_PATH = File.join(File.dirname(__FILE__), "/models")

Dir.glob(MODELS_PATH + "/*.rb").each do |file|
  require file
end

DataMapper::Logger.new(File.join(File.dirname(__FILE__), "/../log/debug.log"), :debug)

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/db/denominations.sqlite3")
DataMapper.finalize
DataMapper.auto_upgrade!

if ENV['REDISTOGO_URL']
  uri = URI.parse(ENV["REDISTOGO_URL"])
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :user => uri.user, :password => uri.password)
else
  if ENV['REDIS_HOST']
    REDIS = Redis.new(:host => ENV['REDIS_HOST'], :port => ENV['REDIS_PORT'])
  else
    REDIS = Redis.new
  end
end

Wine.seed_wines unless REDIS.scard("denomination:all:wines").to_i == 442
Region.seed_regions unless REDIS.scard("regions").to_i == 20
