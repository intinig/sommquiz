require 'json'
require 'sinatra'

require __dir__ + "/lib/somm_quiz"

get '/question' do
  content_type :json
  {"questions" => SommQuiz::Quiz.new(20).questions}.to_json
end

get '/' do
  erb :index
end
