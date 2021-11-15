class FeatureFlag
  class << self
    def active?(feature_name)
      feature = RedisService.current.get("feature_flags_#{feature_name}")

      return false unless feature

      JSON.parse(feature)['state']
    end

    def activate(feature_name)
      raise UnknownFeatureError unless feature_name.in?(features)

      sync_with_redis(feature_name, true)
    end

    def deactivate(feature_name)
      raise UnknownFeatureError unless feature_name.in?(features)

      sync_with_redis(feature_name, false)
    end

    def features
      FeatureFlags.all.map do |name, description, owner|
        [name, FeatureFlag.new(name: name, description: description, owner: owner)]
      end.to_h.with_indifferent_access
    end

    def last_updated(feature_name)
      feature = RedisService.current.get("feature_flags_#{feature_name}")

      return unless feature

      JSON.parse(feature)['updated_at']
    end

  private

    def sync_with_redis(feature_name, feature_state)
      RedisService.current.set(
        "feature_flags_#{feature_name}", { state: feature_state, updated_at: Time.zone.now }.to_json
      )
    end
  end

  attr_accessor :name, :description, :owner, :type

  def initialize(name:, description:, owner:)
    self.name = name
    self.description = description
    self.owner = owner
  end

  class UnknownFeatureError < StandardError; end
end
