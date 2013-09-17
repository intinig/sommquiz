require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'ap'
require 'data_mapper'
require 'sqlite3'

require File.join(File.dirname(__FILE__), '/../lib/models')

DataMapper.auto_upgrade!



def build_description(element, accumulator = "")
  accumulator += element.content
  if element.next_element && element.next_element.name == "p"
    accumulator += build_description(element.next_element, accumulator)
  end
  accumulator
end

def fetch_grape(wine, element, delimiter, pretend = false)
  if element.content =~ delimiter
    wine.grapes = build_description(element.next_element)
    wine.save! unless pretend
    ap wine.grapes if pretend
    ap "[#{pretend ? "pretend" : "updated"}] #{wine.name}"
  end
end

Wine.all.each do |wine|
  source = Nokogiri::HTML(open(wine.link))
  source.css("div.art-article h4").each do |e|
    # special case due to incorrect formatting on AIS site
    if wine.name != "Villamagna DOC"
      fetch_grape(wine, e, /Vitigni/)
    else
      fetch_grape(wine, e, /Zona di produzione/)
    end
  end
end
