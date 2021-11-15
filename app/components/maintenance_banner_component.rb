class MaintenanceBannerComponent < ViewComponent::Base
  include ViewHelper
  def render?
    FeatureFlag.activated?(:maintenance_banner) && !FeatureFlag.activated?(:maintenance_mode)
  end
end
