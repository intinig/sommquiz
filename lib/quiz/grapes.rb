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

      incorrect_answers = wine.grapes.map {|g| g.name}.sample(3)

      build_question(
        "Quali di queste uve non viene utilizzata nella produzione del vino #{wine.name}?",
        correct_answer,
        incorrect_answers,
        "<p><span>Corretto!</span></p>",
        "<p><span>Sbagliato!</span> L'intruso è #{correct_answer}.</p>"
        )
    end

    def grapes_question(n = 1)
      wines = Wine.random(n, :denominations => ["DOCG"], :easy_by_region => false, :exclude_grape_wines => true)
      questions = []
      wines.each do |wine|
        questions << build_grapes_question_with_wine(wine)
      end
      questions
    end

    # che vino si fa con queste uve

    def reverse_grapes_question(n = 1)
      wines = Wine.random(n, :denominations => ["DOCG", "DOC"], :lower_grapes_limit => 3,:easy_by_region => false, :exclude_grape_wines => true)
      questions = []
      wines.each do |wine|
        questions << build_reverse_grapes_question_with_wine(wine)
      end
      questions
    end
  end
end
