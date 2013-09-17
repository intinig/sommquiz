# -*- coding: utf-8 -*-
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'ap'

require File.join(File.dirname(File.absolute_path(__FILE__)), '/../lib/models')

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

Grape.create(:name => "Gamba Rossa")
Grape.create(:name => "Verduno Pelaverga")
Grape.create(:name => "Casavecchia")
Grape.create(:name => "Nero di Troia")
Grape.create(:name => "Girò")
Grape.create(:name => "Semidano")
