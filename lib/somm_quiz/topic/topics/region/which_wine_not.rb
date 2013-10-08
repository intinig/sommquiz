# -*- coding: utf-8 -*-
module SommQuiz
  module Topic
    module RegionExtensions
      module WhichWineNot
        def excluded_regions_from_which_wine_not
          [
            "Abruzzo",
            "Valle d'Aosta",
            "Liguria",
            "Trentino Alto Adige",
            "Molise",
            "Basilicata",
            "Sicilia",
            "Sardegna",
            "Calabria"
          ]
        end

        def which_wine_not_original_region
          @original_region ||= Wine.get_region(which_wine_not_fetch_correct)
        end

        def which_wine_not_fetch_correct
          @correct_answer ||= Wine.sample_outside_region(name)
          @correct_answer.first
        end

        def which_wine_not_fetch_incorrect
          @incorrect_answer ||= [Wine.sample_regional_wines(name)]
        end

        def which_wine_not_answers
          correct = which_wine_not_fetch_correct
          incorrect = which_wine_not_fetch_incorrect.map do |w|
            {:option => w, :correct => false}
          end

          [
            {
              :option => correct,
              :correct => true
            }
          ] + incorrect
        end

        def which_wine_not_subject
          [
            "Quale di questi vini non è prodotto in #{name}?",
            "Quale tra questi due vini non è prodotto in #{name}?"
          ].sample
        end

        def which_wine_not_correct_message
          [
            "Bravo, hai studiato bene!",
            "Complimenti, sei un esperto della regione #{name}"
          ].sample
        end

        def which_wine_not_incorrect_message
          [
            "Ma no! Lo sanno tutti che il vino #{which_wine_not_fetch_correct} è prodotto in #{which_wine_not_original_region}!",
            "Peccato, la risposta giusta era #{which_wine_not_fetch_correct}.",
            "Ti devi impegnare di più... la risposta esatta è #{which_wine_not_fetch_correct}"
          ].sample
        end

      end
    end
  end
end
