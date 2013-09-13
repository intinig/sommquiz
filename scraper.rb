require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'ap'
require './region'
require './region_cluster'

REGIONS_IDS = (184..203).to_a << 97

regions = RegionCluster.new

REGIONS_IDS.each do |region_id|
  source = Nokogiri::HTML(open("http://www.aismilano.it/index.php?option=com_blankcomponent&Itemid=#{region_id}"))
  regions << Region.new(source)
end

ap regions.wines
