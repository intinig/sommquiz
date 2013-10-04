require 'data_mapper'
require 'redis'

MODELS_PATH = File.join(File.dirname(__FILE__), "/models")

Dir.glob(MODELS_PATH + "/*.rb").each do |file|
  require file
end

DataMapper::Logger.new(File.join(File.dirname(__FILE__), "/../log/debug.log"), :debug)

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/db/denominations.sqlite3")
DataMapper.finalize
DataMapper.auto_upgrade!

if ENV['REDIS_HOST']
  REDIS = Redis.new(:host => ENV['REDIS_HOST'], :port => ENV['REDIS_PORT'])
else
  REDIS = Redis.new
end
