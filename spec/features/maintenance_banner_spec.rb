require 'rails_helper'

RSpec.describe 'Maintenance banner' do
  context 'given the maintenance_mode feature flag is active and i arrive at the site' do
    it 'sends me to the maintenance page' do
      FeatureFlag.activate(:maintenance_banner)

      visit '/'

      expect(page).to have_content 'This service will be unavailable on'
    end
  end

  context 'given the maintenance_banner feature flag is deactive and i visit the homepage' do
    it 'sends me to the homepage' do
      FeatureFlag.deactivate(:maintenance_banner)

      visit '/'

      expect(page).not_to have_content 'This service will be unavailable on'
    end
  end
end
