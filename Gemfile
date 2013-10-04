source 'https://rubygems.org'
ruby '2.0.0'

gem 'nokogiri'
gem 'awesome_print'
gem 'data_mapper'
gem 'sinatra'
gem 'recursive-open-struct'
gem 'rake'
gem 'activesupport'
gem 'redis'

group :production do
  gem 'pg'
  gem 'dm-postgres-adapter'
end

group :development, :test do
  gem 'sqlite3'
  gem 'dm-sqlite-adapter'
  gem 'rspec'
  gem 'ZenTest'
  gem 'autotest-growl'
  gem 'autotest-fsevent'
  gem 'ruby-prof'
end
