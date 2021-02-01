module FeatureFlagHelper
  def activate_feature(name)
    allow(Settings.feature_flags).to receive(:send).with(name).and_return true
  end

  def deactivate_feature(name)
    allow(Settings.feature_flags).to receive(:send).with(name).and_return false
  end
end
