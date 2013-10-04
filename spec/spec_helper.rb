ENV['REDIS_HOST'] = "127.0.0.1"
ENV['REDIS_PORT'] = "6380"

RSpec.configure do |config|
  config.before(:all) {}
  config.before(:each) {
    REDIS.flushdb
  }
  config.after(:all) {}
  config.after(:each) {}
end
