# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Cookie consent", type: :feature do
  let(:cookie_preferences_page) { PageObjects::Page::CookiePreferences.new }

  scenario "Navigate to cookies" do
    visit cookie_preferences_path

    expect(page).to have_text("Cookies")
    expect(cookie_preferences_page.cookie_consent_accept).not_to be_checked
    expect(cookie_preferences_page.cookie_consent_deny).not_to be_checked
  end

  scenario "Consent to cookies" do
    visit cookie_preferences_path
    page.choose("Yes, opt-in to Google Analytic cookies")
    click_button "Save changes"

    expect(page).to have_text(I18n.t("cookie_preferences.success"))
    expect(cookie_preferences_page.cookie_consent_accept).to be_checked
    expect(cookie_preferences_page.cookie_consent_deny).not_to be_checked
  end

  scenario "Does not consent to cookies" do
    visit cookie_preferences_path
    page.choose("No, do not track my website usage")
    click_button "Save changes"

    expect(page).to have_text(I18n.t("cookie_preferences.success"))
    expect(cookie_preferences_page.cookie_consent_deny).to be_checked
    expect(cookie_preferences_page.cookie_consent_accept).not_to be_checked
  end

  scenario "No cookie preference selected" do
    visit cookie_preferences_path
    click_button "Save changes"

    expect(page).to have_text(I18n.t("cookie_preferences.no_option_error"))
  end
end
