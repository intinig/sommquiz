# -*- coding: utf-8 -*-
module Quiz
  module Regions
    def build_reverse_region_question_with_region(region)
      denominations = Denomination.all :name => ["DOCG"]
      picolit = Wine.first :name => "Colli Orientali del Friuli Picolit DOCG"
      incorrect_answers = Wine.all(:region => region, :denomination => denominations).sample(3).map{|w| w.name}
      correct_answer = Wine.all(:region.not => region, :denomination => denominations, :id.not => picolit.id).sample(1).map{|w| w.name}.first

      build_question(
        "Quali di questi vini non appartiene alla regione #{region.name}?",
        correct_answer,
        incorrect_answers,
        "<p><span>Corretto!</span></p>",
        "<p><span>Sbagliato!</span> L'intruso è #{correct_answer}!</p>"
        )
    end

    def reverse_region_question(n = 1)
      regions = Region.all.select do |r|
        r.wines.count(:denomination => Denomination.first(:name => "DOCG")) > 2
      end.sample(n)
      questions = []
      regions.each do |region|
        questions << build_reverse_region_question_with_region(region)
      end
      questions
    end

    def region_question(n = 1)
      wines = Wine.random(n, :denominations => ["DOCG"])
      questions = []
      wines.each do |wine|
        questions << build_question(
          "In che regione viene prodotto il vino #{wine.name}?",
          wine.region.name,
          Region.all(:name.not => wine.region.name).sample(3).map{|r| r.name},
          "<p><span>Corretto!</span></p>",
          "<p><span>Sbagliato!</span> Il #{wine.name} viene prodotto nella regione #{wine.region.name}!</p>"
          )
      end
      questions
    end

    # quali di queste regioni ha n docg?
  end
end
