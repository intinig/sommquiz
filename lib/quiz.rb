# -*- coding: utf-8 -*-
require 'rubygems'
require 'ap'

require File.join(File.dirname(__FILE__), "/models")


class Quiz
  def self.sample_wines(n, options = {})
    denominations = options[:denominations] || ["DOC", "DOCG"]
    easy_by_region = options[:easy_by_region]
    excluded_ids = options[:excluded_ids]

    denominations = Denomination.all(:name => denominations)
    wines = Wine.all(:denomination => denominations, :id.not => excluded_ids)

    n = n > wines.count ? wines.count : n

    wines = wines.sample(n)

    excluded_ids = wines.map {|w| w.id}

    new_wines = wines.dup

    unless easy_by_region
      wines.each do |wine|
        new_wines.delete(wine) if wine.name =~ /#{wine.region.name}/i
      end
    end

    if new_wines.size < n
      new_wines << sample_wines(n - wines.size, options.merge(:excluded_ids => excluded_ids))
    end

    new_wines.flatten
  end

  def self.region_question(n = 1)
    wines = sample_wines(n)
    questions = []
    wines.each do |wine|
      results = Region.all(:name.not => wine.region.name).sample(3).map do |region|
        {"option" => region.name, "correct" => false}
      end
      results << {"option" => wine.region.name, "correct" => true}
      questions << {
        "q" => "In che regione viene prodotto il vino #{wine.name}?",
        "a" => results.shuffle,
        "correct" => "<p><span>Corretto!</span></p>",
        "incorrect" => "<p><span>Sbagliato!</span> Il #{wine.name} viene prodotto in #{wine.region.name}!</p>"
      }
    end
    questions
  end

  def self.grapes_question(n = 1)
    wines = sample_wines(n)
    questions = []
    wines.each do |wine|
      results = Wine.all(:name.not => wine.name, :region => wine.region).sample(3).map do |grapes|
        {"option" => grapes.split_grapes.join(", "), "correct" => false}
      end
      results << {"option" => wine.split_grapes.join(", "), "correct" => true}
      questions << {
        "q" => "Con che uve può essere prodotto il vino #{wine.name}?",
        "a" => results.shuffle,
        "correct" => "<p><span>Corretto!</span></p>",
        "incorrect" => "<p><span>Sbagliato!</span> Il #{wine.name} può essere prodotto con #{wine.split_grapes.join(', ')}!</p>"
      }
    end
    questions
  end
end
