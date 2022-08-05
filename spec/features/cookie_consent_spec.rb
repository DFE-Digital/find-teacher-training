# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Cookie consent', type: :feature do
  let(:cookie_preferences_page) { PageObjects::Page::CookiePreferences.new }

  it 'Navigate to cookies' do
    visit cookie_preferences_path

    expect(page).to have_text('Cookies')
    expect(cookie_preferences_page.cookie_consent_accept).not_to be_checked
    expect(cookie_preferences_page.cookie_consent_deny).not_to be_checked
  end

  it 'Consent to cookies' do
    visit cookie_preferences_path
    page.choose('Yes')
    click_button 'Save cookie settings'

    expect(page).to have_text(I18n.t('cookie_preferences.success'))
    expect(cookie_preferences_page.cookie_consent_accept).to be_checked
    expect(cookie_preferences_page.cookie_consent_deny).not_to be_checked
  end

  it 'Does not consent to cookies' do
    visit cookie_preferences_path
    page.choose('No')
    click_button 'Save cookie settings'

    expect(page).to have_text(I18n.t('cookie_preferences.success'))
    expect(cookie_preferences_page.cookie_consent_deny).to be_checked
    expect(cookie_preferences_page.cookie_consent_accept).not_to be_checked
  end

  it 'No cookie preference selected' do
    visit cookie_preferences_path
    click_button 'Save cookie settings'

    expect(page).to have_text('Select yes if you want to accept Google Analytics cookies')
  end
end
