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

  def self.build_question(question, correct_answer, incorrect_answers, correct_message, incorrect_message)
    results = incorrect_answers.map do |answer|
      {"option" => answer, "correct" => false}
    end

    results = (results + [{"option" => correct_answer, "correct" => true}]).shuffle

    {
      "q" => question,
      "a" => results,
      "correct" => correct_message,
      "incorrect"  => incorrect_message
    }
  end

  def self.region_question(n = 1)
    wines = sample_wines(n, :denominations => ["DOCG"])
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

  # C'e' un bug: a volte tira fuori una domanda con due risposte uguali
  # Es. Vermentino di Gallura
  # TODO: reverse questions: Che vino viene fatto con queste uve? Docg di questa regione?

  def self.build_grapes_question_with_wine(wine)
    incorrect_answers = Wine.all(:name.not => wine.name, :grapes.not => wine.grapes, :denomination => wine.denomination).map {|w| w.grapes.map {|g| g.name}.join(", ")}.uniq.sample(3)
    correct_answer = wine.grapes.map {|g| g.name}.join(", ")

    build_question(
      "Con che uve può essere prodotto il vino #{wine.name}?",
      correct_answer,
      incorrect_answers,
      "<p><span>Corretto!</span></p>",
      "<p><span>Sbagliato!</span> Il #{wine.name} può essere prodotto con #{correct_answer}!</p>"
      )
  end

  def self.grapes_question(n = 1)
    wines = sample_wines(n, :denominations => ["DOCG"])
    questions = []
    wines.each do |wine|
      questions << build_grapes_question_with_wine(wine)
    end
    questions
  end

  def self.random_question(n = 1)
    questions = []
    n.times do |i|
      if rand(2).to_i > 0
        questions << region_question
      else
        questions << grapes_question
      end
    end
    questions.flatten
  end

end
