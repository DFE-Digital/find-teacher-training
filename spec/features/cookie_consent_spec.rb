# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Cookie consent", type: :feature do
  scenario "Navigate to cookies" do
    visit cookie_preferences_path

    expect(page).to have_text("Cookies")
  end

  scenario "Consent to cookies" do
    visit cookie_preferences_path
    page.choose("Yes, opt-in to Google Analytic cookies")
    click_button "Save changes"

    expect(page).to have_text(I18n.t("cookie_preferences.success"))
  end

  scenario "Does not consent to cookies" do
    visit cookie_preferences_path
    page.choose("No, do not track my website usage")
    click_button "Save changes"

    expect(page).to have_text(I18n.t("cookie_preferences.success"))
  end

  scenario "No cookie preference selected" do
    visit cookie_preferences_path
    click_button "Save changes"

    expect(page).to have_text(I18n.t("cookie_preferences.no_option_error"))
  end
end
