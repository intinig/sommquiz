require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'ap'
require 'data_mapper'
require 'sqlite3'

require './models'

DataMapper.auto_upgrade!

Wine.all.each do |wine|
  source = Nokogiri::HTML(open(wine.link))
  source.css("div.art-article h4").each do |e|
    if e.content =~ /Vitigni/
      wine.grapes = e.next_element.content
      wine.save!
      ap "Updated #{wine.stripped_name}"
    end
  end
end
