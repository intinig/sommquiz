# -*- coding: utf-8 -*-
module SommQuiz
  module Topic
    module RegionExtensions
      module WhichWine
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

      end
    end
  end
end
