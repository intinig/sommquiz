require 'data_mapper'

require './wine'
require './denomination'
require './region'
require './grape'

#DataMapper::Logger.new($stdout, :debug)

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/db/denominations.sqlite3")
DataMapper.finalize
