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

  describe '.activated?' do
    before do
      allow(FeatureFlags).to receive(:all).and_return([[:test_feature, "It's a test feature", 'Jasmine Java']])
    end

    it 'returns false if the feature flag has been deactivated' do
      described_class.deactivate('test_feature')

      expect(described_class.activated?('test_feature')).to eq(false)
    end

    it 'returns true if the feature flag has been activated' do
      described_class.activate('test_feature')

      expect(described_class.activated?('test_feature')).to eq(true)
    end

    it 'returns false if the feature does not exist' do
      expect(described_class.activated?('test_feature')).to eq(false)
    end
  end

  describe '.deactivate' do
    before do
      allow(FeatureFlags).to receive(:all).and_return([[:test_feature, "It's a test feature", 'Jasmine Java']])
    end

    it 'deactivates the feature flag' do
      described_class.deactivate('test_feature')

      expect(described_class.activated?('test_feature')).to eq(false)
    end
  end

  describe '.activate' do
    before do
      allow(FeatureFlags).to receive(:all).and_return([[:test_feature, "It's a test feature", 'Jasmine Java']])
    end

    it 'activates the feature flag' do
      described_class.activate('test_feature')

      expect(described_class.activated?('test_feature')).to eq(true)
    end
  end
end
