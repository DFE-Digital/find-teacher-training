class FeatureHistoryComponent < ViewComponent::Base
  include ViewHelper

  def initialize(feature_name)
    @feature_name = feature_name
  end

  def status
    FeatureFlag.activated?(@feature_name) ? 'active' : 'inactive'
  end

  def date
    last_updated = FeatureFlag.last_updated(@feature_name)
    DateTime.parse(last_updated).to_s(:govuk_date_and_time)
  end
end
