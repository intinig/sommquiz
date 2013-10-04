require 'json'
require 'sinatra'

require __dir__ + "/lib/somm_quiz"

get '/question' do
  questions = SommQuiz::Quiz.new(20).questions
  content_type :json
  {"questions" => questions}.to_json
end

get '/' do
  erb :index
end
