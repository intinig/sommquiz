ENV['REDIS_HOST'] = "127.0.0.1"
ENV['REDIS_PORT'] = "6380"

RSpec.configure do |config|
  config.fail_fast = true
  config.before(:all) {
    # Wine.seed_wines unless REDIS.scard("denomination:all:wines").to_i == 443
    # Region.seed_regions unless REDIS.scard("regions").to_i == 20
  }
  config.before(:each) {}
  config.after(:all) {
    # REDIS.flushdb
  }
  config.after(:each) {}
end
