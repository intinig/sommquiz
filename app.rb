require 'json'
require './quiz'

# tipi di domande: doc o docg?
# regioni
#

get '/question' do
  content_type :json
  {"questions" => Quiz.region_question(10)}.to_json
end

get '/' do
  erb :index
end
