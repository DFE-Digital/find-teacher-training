require './app/lib/redis_service'

Sidekiq.configure_server do |config|
  config.redis = {
    url: RedisService.redis_url,
  }
  config.logger.level = Logger::WARN

  if Settings.background_jobs
    Sidekiq::Cron::Job.load_from_hash Settings.background_jobs
  end
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: RedisService.redis_url,
  }
end
