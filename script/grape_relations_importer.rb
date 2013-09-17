require 'rubygems'
require 'ap'
require 'data_mapper'

require File.join(File.dirname(File.absolute_path(__FILE__)), '/../lib/models')

DataMapper.auto_upgrade!

Wine.all.each do |wine|
  wine.structured_grapes.each do |g|
    grape = Grape.first :id => g[:gid]
    wine.grapes << grape
    wine.save!
  end
end
