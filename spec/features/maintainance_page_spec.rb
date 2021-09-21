require 'rails_helper'

RSpec.describe 'Maintenance mode', type: :feature do
  context 'given the maintenance_mode feature flag is active and i arrive at the site' do
    it 'sends me to the maintenance page' do
      activate_feature(:maintenance_mode)

      visit '/'

      expect(page).to have_current_path maintainance_path
    end
  end

  context 'given the maintenance_mode feature flag is deactive and i visit the maintenance_path' do
    it 'sends me to the homepage' do
      visit maintainance_path

      expect(page).to have_current_path root_path
    end
  end
end
