desc "Open an irb session preloaded with this library"
task :console do
  ENV["REDIS_HOST"] = "127.0.0.1"
  ENV["REDIS_PORT"] = "6380"
  sh "irb -rubygems -I . -r lib/somm_quiz.rb"
end
