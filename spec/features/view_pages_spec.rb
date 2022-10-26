# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'View pages' do
  it 'Navigate to privacy' do
    visit privacy_path

    expect(page).to have_text('Privacy policy')
  end

  it 'Navigate to accessibility' do
    visit accessibility_path

    expect(page).to have_text('Accessibility statement for Find postgraduate teacher training')
  end

  it 'Navigate to terms' do
    visit terms_path

    expect(page).to have_text('Terms and conditions')
  end
end
