require './app/lib/redis'

class SiteSetting < Base
  def self.cycle_schedule
    RedisService.new.get('cycle_schedule')&.to_sym || :real
  end

  def self.set(name:, value:)
    RedisService.new.set(name, value)
  end
end
