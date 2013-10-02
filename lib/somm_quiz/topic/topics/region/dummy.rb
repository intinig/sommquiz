# -*- coding: utf-8 -*-
module SommQuiz
  module Topic
    module RegionExtensions
      module Dummy
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

      end
    end
  end
end
