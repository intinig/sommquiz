# -*- coding: utf-8 -*-
require 'rubygems'
require 'ap'

require File.join(File.dirname(__FILE__), "/models")

QUESTIONS_PATH = File.join(File.dirname(__FILE__), "/quiz")

Dir.glob(QUESTIONS_PATH + "/*.rb").each do |file|
  require file
end

module Quiz
  extend Regions
  extend Grapes

  # def self.build_question(options = {})
  #   question = options.delete :question
  #   correct_answer = options.delete :correct_answer
  # end

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

  def self.random_question(n = 1)
    question_types = [
      :region_question,
      :reverse_region_question,
      :grapes_question,
      :reverse_grapes_question,
      :reverse_wine_question
    ]
    questions = []

    n.times do
      questions << Quiz.send(question_types.sample)
    end
    questions.flatten
  end

end
