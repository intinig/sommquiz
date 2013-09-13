require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'ap'
require 'data_mapper'
require 'sqlite3'

require './wine_source'
require './wine_region'
require './region_cluster'
require './region'
require './denomination'
require './wine'

REGIONS_IDS = (184..203).to_a << 97

regions = RegionCluster.new

REGIONS_IDS.each do |region_id|
  source = Nokogiri::HTML(open("http://www.aismilano.it/index.php?option=com_blankcomponent&Itemid=#{region_id}"))
  regions << WineRegion.new(source)
end

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, "sqlite://#{Dir.pwd}/db/denominations.sqlite3")
DataMapper.finalize
DataMapper.auto_migrate!

regions.regions.each do |region|
  region.denominations.each do |denomination, wines|
    wines.each do |wine, link|
      source = WineSource.new(
        :region => Region.first_or_create(:name => region.name),
        :denomination => Denomination.first_or_create(:name => denomination),
        :name => wine,
        :link => "http://www.aismilano.it" + link
        )
      source.save!
    end
  end
end
