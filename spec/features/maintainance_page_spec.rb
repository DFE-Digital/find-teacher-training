require 'rails_helper'

RSpec.describe 'Maintenance mode', type: :feature do
  context 'given the maintenance_mode feature flag is active and i arrive at the site' do
    it 'sends me to the maintenance page' do
      activate_feature(:maintenance_mode)
      activate_feature(:maintenance_banner)

      visit '/'

      expect(page).to have_current_path maintainance_path
      expect(page).not_to have_content 'This service will be unavailable on'
    end
  end

  context 'given the maintenance_mode feature flag is deactive and i visit the maintenance_path' do
    it 'sends me to the homepage' do
      deactivate_feature(:maintenance_mode)

      visit maintainance_path

      expect(page).to have_current_path root_path
    end
  end
end
