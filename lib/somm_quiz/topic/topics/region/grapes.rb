# -*- coding: utf-8 -*-
module SommQuiz
  module Topic
    module RegionExtensions
      module Grapes
        def grapes_fetch_correct
          if @correct_answer
            @correct_answer
          else
            @correct_answer = @data.grapes.sample(5).map {|w| w.name}
          end
        end

        def grapes_fetch_incorrect
          if @incorrect_answer
            @incorrect_answer
          else
            Grape.all.select do |grape|
              !grape.regions.include?(@data)
            end.sample(5).map {|w| w.name}
          end
        end

        def grapes_answers
          correct = grapes_fetch_correct.map do |w|
            {:option => w, :correct => true}
          end

          incorrect = grapes_fetch_incorrect.map do |w|
            {:option => w, :correct => false}
          end

          (correct + incorrect)
        end

        def grapes_subject
          [
            "Cinque di questi vitigni sono usati nella regione #{name}. Quali?",
          ].sample
        end

        def grapes_correct_message
          [
            "Bravo, hai studiato bene!",
            "Complimenti, sei un esperto della regione #{name}",
          ].sample
        end

        def grapes_incorrect_message
          [
            "Peccato, la risposta giusta era: #{grapes_fetch_correct.join(", ")}.",
          ].sample
        end

      end
    end
  end
end
