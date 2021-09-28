require 'redis'
class RedisService
  def self.new
    Redis.new(url: RedisService.redis_url)
  end

  def self.redis_url
    @redis_credentials ||= begin
      redis_credentials = ENV['REDIS_URL'] || Settings.redis_url
      if ENV.key?('VCAP_SERVICES')
        ENV.fetch('REDIS_WORKER_URL')
      end
      redis_credentials
    end
  end
end
