# -*- coding: utf-8 -*-
require __dir__ + "/../../../../lib/models"
require __dir__ + "/region/which_wine"
require __dir__ + "/region/which_wine_not"
require __dir__ + "/region/which_grape"
require __dir__ + "/region/which_grape_not"
require __dir__ + "/region/grapes"
require __dir__ + "/region/dummy"

module SommQuiz
  module Topic
    class Region < Base
      include RegionExtensions::WhichWine
      include RegionExtensions::WhichWineNot
      include RegionExtensions::WhichGrape
      include RegionExtensions::WhichGrapeNot
      include RegionExtensions::Grapes
      include RegionExtensions::Dummy

      def denominations
        Denomination.all :name => "DOCG"
      end

      def self.availability
        Object::Region.count
      end

      def initialize(options = {})
        exclude = options[:exclude]
        @data = Object::Region.all(:name.not => exclude).sample
        @name = @data.name
      end

      def pick_subject(question_type)
        send("#{question_type}_subject")
      end

      def question_types
        types = ['which_grape', 'which_grape_not', 'grapes']
        types << 'which_wine' unless excluded_regions_from_which_wine.include?(name)
        types << 'which_wine_not' unless excluded_regions_from_which_wine_not.include?(name)
        types
      end

      def pick_question_type
        if question_types.empty?
          'dummy'
        else
          question_types.sample
        end
      end

      def generate_answers_for(question_type)
        send("#{question_type}_answers").shuffle
      end

      def generate_correct_message_for(question_type)
        send("#{question_type}_correct_message")
      end

      def generate_incorrect_message_for(question_type)
        send("#{question_type}_incorrect_message")
      end

      def ask
        @correct_answer = nil
        question_type = pick_question_type
        Question.new(
          :subject => pick_subject(question_type),
          :answers  => generate_answers_for(question_type),
          :correct => generate_correct_message_for(question_type),
          :incorrect => generate_incorrect_message_for(question_type),
          :select_any => true
          )
      end
    end
  end
end
