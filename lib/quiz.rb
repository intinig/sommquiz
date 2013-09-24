# -*- coding: utf-8 -*-
require 'rubygems'
require 'ap'

require File.join(File.dirname(__FILE__), "/models")


class Quiz
  def self.sample_wines(n, options = {})
    denominations = options[:denominations] || ["DOC", "DOCG"]
    easy_by_region = options[:easy_by_region]
    excluded_ids = options[:excluded_ids]
    grapes_limit = 6

    denominations = Denomination.all(:name => denominations)
    wines = Wine.all(:denomination => denominations, :id.not => excluded_ids)

    n = n > wines.count ? wines.count : n

    wines = wines.sample(n)

    excluded_ids = wines.map {|w| w.id}

    unless easy_by_region
      wines.delete_if do |wine|
        wine.name =~ /#{wine.region.name}/i
      end
    end

    wines.delete_if do |wine|
      wine.grapes.size > 5
    end

    if wines.size < n
      wines << sample_wines(n - wines.size, options.merge(:excluded_ids => excluded_ids))
    end

    wines.flatten
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
    wines = sample_wines(n, :denominations => ["DOCG", "DOC", "DOP"])
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

  # TODO: reverse questions: Che vino viene fatto con queste uve? Docg di questa regione?

  def self.build_grapes_question_with_wine(wine)
# :grapes.not => [{:id => wine.grapes.map{|g| g.id}}],
    incorrect_answers = Wine.all(:name.not => wine.name, :denomination => wine.denomination).select do |w|
      w if w.grapes.size < 6 && (w.grapes - wine.grapes).empty?
    end.map {|w| w.grapes.map {|g| g.name}.join(", ")}.uniq.sample(3)

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

  def self.build_reverse_region_question_with_region(region)
    denominations = Denomination.all :name => ["DOC", "DOCG", "DOP"]
    incorrect_answers = Wine.all(:region => region, :denomination => denominations).sample(3).map{|w| w.name}
    correct_answer = Wine.all(:region.not => region, :denomination => denominations).sample(1).map{|w| w.name}.first

    build_question(
      "Quali di questi vini non appartiene alla regione #{region.name}?",
      correct_answer,
      incorrect_answers,
      "<p><span>Corretto!</span></p>",
      "<p><span>Sbagliato!</span> L'intruso è #{correct_answer}!</p>"
      )
  end

  def self.reverse_region_question(n = 1)
    regions = Region.all.sample(n)
    questions = []
    regions.each do |region|
      questions << build_reverse_region_question_with_region(region)
    end
    questions
  end

  # quali di queste uve non e' in questo vino?

  def self.random_question(n = 1)
    question_types = [Proc.new{region_question}, Proc.new{reverse_region_question}, Proc.new{grapes_question}]
    questions = []
    n.times do
      questions << question_types.sample.call
    end
    questions.flatten
  end

end
