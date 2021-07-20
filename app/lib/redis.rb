require 'redis'
class RedisService
  def self.new
    Redis.new(url: RedisService.redis_url)
  end

  def self.redis_url
    @redis_credentials ||= begin
      redis_credentials = ENV['REDIS_URL']
      if ENV.key?('VCAP_SERVICES')
        service_config = JSON.parse(ENV['VCAP_SERVICES'])
        redis_config = service_config['redis'].first
        vcap_redis_credentials = redis_config['credentials']
        redis_credentials = vcap_redis_credentials['uri']
      end
      redis_credentials
    end
  end
end
