require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'ap'

require File.join(File.dirname(__FILE__), '/../lib/models')

DataMapper.auto_upgrade!

source = Nokogiri::HTML(open("http://it.wikipedia.org/wiki/Vitigno"))


def fetch_grapes(source, css_id)
  grape_cluster = source.css(css_id)
  grape_cluster.first.parent.next_element.css("li").map {|e| e.content}.each do |g|
    grape = Grape.new :name => g
    grape.save!
  end
end

fetch_grapes(source, "#Rossi")
fetch_grapes(source, "#Bianchi")
