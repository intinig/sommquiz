require './wine'
require './denomination'
require './region'

#DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, "sqlite://#{Dir.pwd}/db/denominations.sqlite3")
DataMapper.finalize
