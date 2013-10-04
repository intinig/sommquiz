require 'json'
require 'sinatra'
begin
  require 'ruby-prof'
rescue
end

require __dir__ + "/lib/somm_quiz"

get '/question' do
  begin
    RubyProf.start
  rescue
  end
  questions = SommQuiz::Quiz.new(20).questions
  begin
    result = RubyProf.stop
    printer = RubyProf::GraphHtmlPrinter.new(result)
    File.open "./profiler.html", "w+" do |file|
      printer.print(file)
    end
  rescue
  end
  content_type :json
  {"questions" => questions}.to_json
end

get '/' do
  erb :index
end
