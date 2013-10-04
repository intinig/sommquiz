# -*- coding: utf-8 -*-
module SommQuiz
  module Topic
    module RegionExtensions
      module WhichGrapeNot
        def which_grape_not_fetch_correct
          @correct_answer ||= Object::Grape.sample_not_in_region(name).first
        end

        def which_grape_not_fetch_incorrect
          @incorrect_answer ||= Grape.sample_regional(name, 4)
        end

        def which_grape_not_answers
          correct = which_grape_not_fetch_correct
          incorrect = which_grape_not_fetch_incorrect.map do |w|
            {:option => w, :correct => false}
          end

          [
            {
              :option => correct,
              :correct => true
            }
          ] + incorrect
        end

        def which_grape_not_subject
          [
            "Quale di questi vitigni non è utilizzato nella regione #{name}?",
          ].sample
        end

        def which_grape_not_correct_message
          [
            "Bravo, hai studiato bene!",
            "Complimenti, sei un esperto della regione #{name}",
          ].sample
        end

        def which_grape_not_incorrect_message
          [
            "Peccato, la risposta giusta era #{which_wine_fetch_correct}.",
            "Ti devi impegnare di più... la risposta esatta è #{which_wine_fetch_correct}"
          ].sample
        end

      end
    end
  end
end
