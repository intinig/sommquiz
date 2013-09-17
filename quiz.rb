# -*- coding: utf-8 -*-
require 'rubygems'
require 'ap'

require './models'


class Quiz
  def self.sample_wines(n, exclude = ["IGP"])
    wines = Wine.all(:denomination => Denomination.all(:name.not => exclude)).sample(n)
    wines.each do |wine|
      wines.delete(wine) if wine.name =~ /#{wine.region.name}/i
    end

    if wines.size < n
      wines << sample_wines(n - wines.size, exclude)
    end

    wines.flatten
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
