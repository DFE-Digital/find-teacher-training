require 'rails_helper'

RSpec.describe 'Feature flags', type: :feature do
  scenario 'Manage features' do
    given_there_is_a_feature_flag_set_up

    when_i_visit_the_features_page
    then_i_should_see_the_existing_feature_flags

    when_i_activate_the_feature
    then_the_feature_is_activated
    and_i_can_see_the_activation

    when_i_deactivate_the_feature
    then_the_feature_is_deactivated
    and_i_can_see_the_deactivation
  end

  def given_there_is_a_feature_flag_set_up
    allow(FeatureFlags).to receive(:all).and_return(
      [[:test_feature, "It's a test feature", 'Jasmine Java']],
    )

    FeatureFlag.deactivate('test_feature')
  end

  def when_i_visit_the_features_page
    visit feature_flags_path
  end

  def then_i_should_see_the_existing_feature_flags
    within('.app-summary-card', text: 'Test feature') do
      expect(page).to have_content('Test feature')
      expect(page).to have_content(feature.owner)
      expect(page).to have_content(feature.description)
    end
  end

  def when_i_activate_the_feature
    within(pilot_open_summary_card) { click_link 'Confirm environment to make changes' }
    fill_in 'Type ‘test’ to confirm that you want to proceed', with: 'test'
    click_button 'Continue'

    within(pilot_open_summary_card) { click_button 'Activate' }
  end

  def then_the_feature_is_activated
    expect(page).to have_content('Active')
    expect(FeatureFlag.active?('test_feature')).to be true
  end

  def and_i_can_see_the_activation
    expect(page).to have_content('Changed to active')
  end

  def when_i_deactivate_the_feature
    within(pilot_open_summary_card) { click_button 'Deactivate' }
  end

  def then_the_feature_is_deactivated
    expect(page).to have_content('Inactive')
    expect(FeatureFlag.active?('Test feature')).to be false
  end

  def and_i_can_see_the_deactivation
    expect(page).to have_content('Changed to inactive')
  end

  def pilot_open_summary_card
    find('.app-summary-card', text: 'Test feature')
  end

  def feature
    @feature ||= FeatureFlag::FEATURES[:test_feature]
  end
end
