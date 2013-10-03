# -*- coding: utf-8 -*-
module SommQuiz
  module Topic
    module RegionExtensions
      module WhichGrape
        def which_grape_fetch_correct
          if @correct_answer
            @correct_answer
          else
            grapes = @data.grapes
            @correct_answer = grapes.sample.name
          end
        end

        def which_grape_fetch_incorrect
          if @incorrect_answer
            @incorrect_answer
          else
            Grape.all.select do |grape|
              !grape.regions.include?(@data)
            end.sample(4).map {|w| w.name}
          end
        end

        def which_grape_answers
          correct = which_grape_fetch_correct
          incorrect = which_grape_fetch_incorrect.map do |w|
            {:option => w, :correct => false}
          end

          [
            {
              :option => correct,
              :correct => true
            }
          ] + incorrect
        end

        def which_grape_subject
          [
            "Quale di questi vitigni è utilizzato in #{name}?",
          ].sample
        end

        def which_grape_correct_message
          [
            "Bravo, hai studiato bene!",
            "Complimenti, sei un esperto della regione #{name}",
          ].sample
        end

        def which_grape_incorrect_message
          [
            "Peccato, la risposta giusta era #{which_wine_fetch_correct}.",
            "Ti devi impegnare di più... la risposta esatta è #{which_wine_fetch_correct}"
          ].sample
        end

      end
    end
  end
end
