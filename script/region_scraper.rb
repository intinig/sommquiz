require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'ap'
require 'data_mapper'
require 'sqlite3'

require File.join(File.dirname(File.absolute_path(__FILE__)), '/../lib/wine_region')
require File.join(File.dirname(File.absolute_path(__FILE__)), '/../lib/region_cluster')
require File.join(File.dirname(File.absolute_path(__FILE__)), '/../lib/models')

REGIONS_IDS = (184..203).to_a << 97

regions = RegionCluster.new

REGIONS_IDS.each do |region_id|
  source = Nokogiri::HTML(open("http://www.aismilano.it/index.php?option=com_blankcomponent&Itemid=#{region_id}"))
  regions << WineRegion.new(source)
end

DataMapper.auto_migrate!

regions.regions.each do |region|
  region.denominations.each do |denomination, wines|
    wines.each do |wine, link|
      source = Wine.new(
        :region => Region.first_or_create(:name => region.name),
        :denomination => Denomination.first_or_create(:name => denomination),
        :name => wine,
        :link => "http://www.aismilano.it" + link
        )
      source.save!
    end
  end
end
