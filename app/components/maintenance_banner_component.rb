class MaintenanceBannerComponent < ViewComponent::Base
  include ViewHelper
  def render?
    FeatureFlag.active?(:maintenance_banner)
  end
end
