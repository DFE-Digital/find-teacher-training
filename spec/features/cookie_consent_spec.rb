# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Cookie consent", type: :feature do
  scenario "Navigate to cookies" do
    visit cookie_preferences_path

    expect(page).to have_text("Cookies")
  end
end
