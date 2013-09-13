require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'ap'

class RegionCluster
  attr_accessor :regions

  def initialize
    @regions = []
  end

  def <<(region)
    @regions << region
  end

  def wines
    @regions.map {|r| {r.name => r.wine_keys}}
  end
end

class Region
  attr_reader :name, :denominations

  def initialize source
    @source = source
    @name = source.css('title').first.content
    @denominations = {}

    populate_denominations
  end

  def populate_denominations
    @source.css("h3.t").each do |d|
      populate_wines(denomination(d.content), d)
    end
  end

  def denomination content
    @denominations[clean_denomination(content)] ||= {}
  end

  def clean_denomination content
    content.match(/(docg|dop|doc|igp|igt)/i)[1]
  end

  def populate_wines appellation, d
    d.parent.next.css("td h4 a").each do |wine|
      appellation[wine.content] = wine['href']
    end
  end

  def denomination_keys
    @denominations.keys
  end

  def wine_keys
    result = {}
    @denominations.each do |k, v|
      result[k] = v.keys
    end
    result
  end
end

REGIONS_IDS = (184..203).to_a << 97

regions = RegionCluster.new

REGIONS_IDS.each do |region_id|
  source = Nokogiri::HTML(open("http://www.aismilano.it/index.php?option=com_blankcomponent&Itemid=#{region_id}"))
  regions << Region.new(source)
end
