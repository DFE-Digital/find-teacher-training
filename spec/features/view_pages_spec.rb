# frozen_string_literal: true

require "rails_helper"

RSpec.feature "View pages", type: :feature do
  scenario "Navigate to home" do
    visit "/pages/home"

    expect(page).to have_text("Lorem")
  end

  scenario "Navigate to cookies" do
    visit cookies_path

    expect(page).to have_text("Cookies")
  end

  scenario "Navigate to privacy" do
    visit privacy_path

    expect(page).to have_text("Privacy policy")
  end

  scenario "Navigate to accessibility" do
    visit accessibility_path

    expect(page).to have_text("Accessibility statement for Find teacher training courses")
  end

  scenario "Navigate to terms" do
    visit terms_path

    expect(page).to have_text("Terms and Conditions")
  end
end
