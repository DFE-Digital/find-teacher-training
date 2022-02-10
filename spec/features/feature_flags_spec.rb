require 'rails_helper'

RSpec.describe 'Feature flags', type: :feature do
  around do |example|
    Timecop.freeze(Time.zone.local(2021, 12, 1, 12)) do
      example.run
    end
  end

  scenario 'Manage features' do
    given_there_is_a_feature_flag_set_up

    when_i_visit_the_features_page
    then_i_should_see_the_existing_feature_flags

    when_i_activate_the_feature
    then_the_feature_is_activated

    when_i_deactivate_the_feature
    then_the_feature_is_deactivated
  end

  def given_there_is_a_feature_flag_set_up
    allow(FeatureFlags).to receive(:all).and_return([[:test_feature, "It's a test feature", 'Jasmine Java']])

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
    within(summary_card) { click_link 'Confirm environment to make changes' }
    fill_in 'Type ‘test’ to confirm that you want to proceed', with: 'test'
    click_button 'Continue'
    stub_activate_slack_notification_job

    within(summary_card) { click_button 'Activate' }
  end

  def then_the_feature_is_activated
    expect(FeatureFlag.active?('test_feature')).to be true
    expect(page).to have_content('Feature ‘Test feature’ activated')
    expect(page).to have_content('Active')
    expect(page).to have_content('12pm on 1 December 2021')
  end

  def when_i_deactivate_the_feature
    stub_deactivate_slack_notification_job
    within(summary_card) { click_button 'Deactivate' }
  end

  def then_the_feature_is_deactivated
    expect(page).to have_content('Inactive')
    expect(FeatureFlag.active?('test_feature')).to be false
  end

  def summary_card
    find('.app-summary-card', text: 'Test feature')
  end

  def feature
    @feature ||= FeatureFlag.features[:test_feature]
  end

  def stub_activate_slack_notification_job
    stub_request(:post, 'https://example.com/webhook')
      .with(
        body: '{"username":"Find postgraduate teacher training","channel":"#twd_apply_test","text":"[TEST] \\u003c/feature-flags|:flags: Feature ‘test_feature‘ was activated\\u003e","mrkdwn":true,"icon_emoji":":livecanary:"}',
        headers: {
          'Connection' => 'close',
          'Host' => 'example.com',
          'User-Agent' => 'http.rb/5.0.4',
        },
      )
      .to_return(status: 200, body: '', headers: {})
  end

  def stub_deactivate_slack_notification_job
    stub_request(:post, 'https://example.com/webhook')
      .with(
        body: '{"username":"Find postgraduate teacher training","channel":"#twd_apply_test","text":"[TEST] \\u003c/feature-flags|:flags: Feature ‘test_feature‘ was deactivated\\u003e","mrkdwn":true,"icon_emoji":":livecanary:"}',
        headers: {
          'Connection' => 'close',
          'Host' => 'example.com',
          'User-Agent' => 'http.rb/5.0.4',
        },
      )
      .to_return(status: 200, body: '', headers: {})
  end
end
