# -*- coding: utf-8 -*-
module Quiz
  module Grapes
    def build_grapes_question_with_wine(wine)
      correct_answer = wine.grapes.map {|g| g.name}.sort.join(", ")

      wines = Wine.all(:name.not => wine.name, :denomination => wine.denomination)

      incorrect_answers = wines.select do |w|
        w if w.grapes.size < 6 && !(w.grapes - wine.grapes).empty?
      end.map {|w| w.grapes.map {|g| g.name}.sort.join(", ")}.uniq.sample(3)


      build_question(
        "Con che uve può essere prodotto il vino #{wine.name}?",
        correct_answer,
        incorrect_answers,
        "<p><span>Corretto!</span></p>",
        "<p><span>Sbagliato!</span> Il #{wine.name} può essere prodotto con #{correct_answer}!</p>"
        )
    end

    def build_reverse_grapes_question_with_wine(wine)
      correct_answer = Grape.all.select {|g| !wine.grapes.include?(g)}.sample.name

      incorrect_answers = wine.grapes.map {|g| g.name}

      build_question(
        "Quali di queste uve non viene utilizzata nella produzione del vino #{wine.name}?",
        correct_answer,
        incorrect_answers,
        "<p><span>Corretto!</span></p>",
        "<p><span>Sbagliato!</span> L'intruso è #{correct_answer}.</p>"
        )
    end

    def grapes_question(n = 1)
      wines = Wine.random(n, :denominations => ["DOCG"])
      questions = []
      wines.each do |wine|
        questions << build_grapes_question_with_wine(wine)
      end
      questions
    end

    def reverse_grapes_question(n = 1)
      wines = Wine.random(n, :denominations => ["DOCG"])
      wines.select {|w| w.grapes.size > 4}
      questions = []
      wines.each do |wine|
        questions << build_reverse_grapes_question_with_wine(wine)
      end
      questions
    end
  end
end
