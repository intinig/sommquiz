require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'ap'
require 'data_mapper'
require 'sqlite3'

require './wine_region'
require './region_cluster'
require './wine_source'

# DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, "sqlite://#{Dir.pwd}/db/denominations.sqlite3")
DataMapper.finalize
DataMapper.auto_upgrade!

WineSource.docg.each do |wine|
  source = Nokogiri::HTML(open(wine.link))
  source.css("div.art-article h4").each do |e|
    ap wine.name + " -- " + e.next_element.content if e.content =~ /Vitigni/
  end
end
