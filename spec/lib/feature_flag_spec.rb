require 'rails_helper'

RSpec.describe FeatureFlag do
  include FeatureFlagHelper

  describe '.active?' do
    let(:feature_name) { 'some test feature' }

    it 'returns true if the matching feature is active' do
      activate_feature(feature_name)
      expect(FeatureFlag.active?(feature_name)).to eq true
    end

    it 'returns false if the matching feature is not active' do
      deactivate_feature(feature_name)
      expect(FeatureFlag.active?(feature_name)).to eq false
    end

    it 'raises an error if the feature name is not recognised' do
      expect { FeatureFlag.active?('some undefined feature') }.to raise_error(FeatureFlag::UnknownFeatureError)
    end
  end
end
