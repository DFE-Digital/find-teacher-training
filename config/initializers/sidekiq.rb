require './app/lib/redis'

Sidekiq.configure_server do |config|
  config.redis = {
    url: RedisService.redis_url,
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: RedisService.redis_url,
  }
end
