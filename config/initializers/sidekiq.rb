redis_url = ENV.fetch('REDIS_URL') { 'redis://localhost:6379/0' }

module RedisClient
  class << self
    def redis
      @redis ||= Redis.new(url: redis_url)
    end
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }
end