module FeatureFlagHelper
  def activate_feature(name)
    initialize_stub
    allow(Settings.feature_flags).to receive(:send).with(name).and_return true
  end

  def deactivate_feature(name)
    initialize_stub
    allow(Settings.feature_flags).to receive(:send).with(name).and_return false
  end

private

  def initialize_stub
    @_stub_initialized ||= allow(Settings.feature_flags).to receive(:send).and_call_original
  end
end
