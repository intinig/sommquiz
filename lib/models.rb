require 'data_mapper'

MODELS_PATH = File.join(File.dirname(__FILE__), "/models")

Dir.glob(MODELS_PATH + "/*.rb").each do |file|
  require file
end

DataMapper::Logger.new(File.join(File.dirname(__FILE__), "/../log/debug.log"), :debug)

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/db/denominations.sqlite3")
DataMapper.finalize
