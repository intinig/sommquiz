require File.join(File.dirname(__FILE__), "/models")

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
