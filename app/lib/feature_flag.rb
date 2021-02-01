class FeatureFlag
  def self.active?(feature)
    setting = Settings.feature_flags.send(feature)
    raise UnknownFeatureError if !setting.in? [true, false]

    setting
  end

  class UnknownFeatureError < StandardError; end
end
