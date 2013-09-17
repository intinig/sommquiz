require 'json'
require 'sinatra'

require File.join(File.dirname(__FILE__), "/lib/quiz")

# tipi di domande: doc o docg?
# regioni
#

get '/question' do
  content_type :json
  {"questions" => Quiz.grapes_question(10)}.to_json
end

get '/' do
  erb :index
end
