require './app/lib/redis'

class SiteSetting < Base
  def self.cycle_schedule
    RedisService.current.get('cycle_schedule')&.to_sym || :real
  end

  def self.set(name:, value:)
    RedisService.current.set(name, value)
  end
end
