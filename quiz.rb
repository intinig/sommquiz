require 'rubygems'
require 'ap'
require 'data_mapper'

require './models'


class Quiz
  def self.region_question(n = 1)
    questions = []
    wines = Wine.all.sample(n)
    wines.each do |wine|
      results = Region.all(:name.not => wine.region.name).sample(3).map do |region|
        {"option" => region.name, "correct" => false}
      end
      results << {"option" => wine.region.name, "correct" => true}
      questions << {
        "q" => "In che regione viene prodotto il #{wine.name}?",
        "a" => results.shuffle,
        "correct" => "<p><span>Corretto!</span></p>",
        "incorrect" => "<p><span>Sbagliato!</span> Il #{wine.name} viene prodotto in #{wine.region.name}!</p>"
      }
    end
    questions
  end
end
