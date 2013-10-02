# -*- coding: utf-8 -*-
require __dir__ + "/../../../../lib/models"

module SommQuiz
  module Topic
    class Region < Base

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

      def excluded_regions_from_which_wine
        [
          "Abruzzo",
          "Valle d'Aosta",
          "Liguria",
          "Trentino Alto Adige",
          "Molise",
          "Calabria"
        ]
      end

      def question_types
        types = []
        types << 'which_wine' unless excluded_regions_from_which_wine.include?(name)
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
        send("#{question_type}_answers")
      end

      def generate_correct_message_for(question_type)
        send("#{question_type}_correct_message")
      end

      def generate_incorrect_message_for(question_type)
        send("#{question_type}_incorrect_message")
      end

      def dummy_subject
        "Quale è il nome della regione #{name}?"
      end

      def dummy_answers
        [
          {:option => name, :correct => true},
          {:option => name, :correct => true}
        ]
      end

      def dummy_correct_message
        "Che bravo! Ma non ti gasare, questa domanda non ci dovrebbe essere, è solo un test."
      end

      def dummy_incorrect_message
        "Difficile poter sbagliare una domanda tautologica, come hai fatto?"
      end

      def which_wine_fetch_correct
        if @correct_answer
          @correct_answer
        else
          wines = @data.wines(:denomination => denominations)
          if wines.empty?
            raise "[BUG] Fixme: #{name}"
          else
            @correct_answer = wines.sample.name
          end
        end
      end

      def which_wine_fetch_incorrect
        Wine.all(
          :region.not => @data,
          :denomination => denominations
          ).sample(4).map {|w| w.name}
      end

      def which_wine_answers
        correct = which_wine_fetch_correct
        incorrect = which_wine_fetch_incorrect.map do |w|
          {:option => w, :correct => false}
        end

        [
          {
            :option => correct,
            :correct => true
          }
        ] + incorrect
      end

      def which_wine_subject
        [
          "Quale di questi vini è prodotto in #{name}?",
          "Quale famoso vino è prodotto in #{name}?",
          "Per quale di questi vini è famosa la regione #{name}?"
        ].sample
      end

      def which_wine_correct_message
        [
          "Bravo, hai studiato bene!",
          "Complimenti, sei un esperto della regione #{name}",
          "Bravo! Chissà quanto ne hai bevuto di #{which_wine_fetch_correct}, eh?"
        ].sample
      end

      def which_wine_incorrect_message
        [
          "Ma no! Lo sanno tutti che il vino #{which_wine_fetch_correct} è prodotto in #{name}!",
          "Peccato, la risposta giusta era #{which_wine_fetch_correct}.",
          "Ti devi impegnare di più... la risposta esatta è #{which_wine_fetch_correct}"
        ].sample
      end

      def ask
        @correct_answer = nil
        question_type = pick_question_type
        Question.new(
          :subject => pick_subject(question_type),
          :answers  => generate_answers_for(question_type),
          :correct => generate_correct_message_for(question_type),
          :incorrect => generate_incorrect_message_for(question_type)
          )
      end
    end
  end
end
