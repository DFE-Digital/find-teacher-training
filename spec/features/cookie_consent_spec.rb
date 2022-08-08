# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Cookie consent', type: :feature do
  let(:cookie_preferences_page) { PageObjects::Page::CookiePreferences.new }

  before do
    cookie_preferences_page.load
  end

  it 'Navigate to cookies' do
    expect(page).to have_text('Cookies')
    expect(cookie_preferences_page.analytics_cookie_accept).not_to be_checked
    expect(cookie_preferences_page.analytics_cookie_deny).not_to be_checked
  end

  it 'Consent to cookies' do
    cookie_preferences_page.analytics_cookie_accept.choose
    cookie_preferences_page.marketing_cookie_accept.choose
    click_button 'Save cookie settings'

    expect(page).to have_text(I18n.t('cookie_preferences.success'))
    expect(cookie_preferences_page.analytics_cookie_accept).to be_checked
    expect(cookie_preferences_page.marketing_cookie_accept).to be_checked
    expect(cookie_preferences_page.analytics_cookie_deny).not_to be_checked
    expect(cookie_preferences_page.marketing_cookie_deny).not_to be_checked
  end

  it 'Does not consent to cookies' do
    cookie_preferences_page.analytics_cookie_deny.choose
    cookie_preferences_page.marketing_cookie_deny.choose
    click_button 'Save cookie settings'

    expect(page).to have_text(I18n.t('cookie_preferences.success'))
    expect(cookie_preferences_page.analytics_cookie_deny).to be_checked
    expect(cookie_preferences_page.marketing_cookie_deny).to be_checked
    expect(cookie_preferences_page.analytics_cookie_accept).not_to be_checked
    expect(cookie_preferences_page.marketing_cookie_accept).not_to be_checked
  end

  it 'No cookie preference selected' do
    click_button 'Save cookie settings'

    expect(page).to have_text('Select yes if you want to accept Google Analytics cookies')
    expect(page).to have_text('Select yes if you want to accept Marketing cookies')
  end
end
