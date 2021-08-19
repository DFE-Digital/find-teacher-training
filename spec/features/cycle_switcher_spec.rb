# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Cycle switcher', type: :feature do
  it 'Navigates to the cycle switcher' do
    visit switch_cycle_schedule_path

    expect(page).to have_text('Current point in the recruitment cycle')
  end

  it 'show the deadline banner' do
    visit switch_cycle_schedule_path
    page.choose 'Mid cycle and deadlines should be displayed'
    click_button 'Update point in recruitment cycle'
    visit root_path

    expect(page).to have_text('If you’re applying for the first time since applications opened in October 2020')
  end

  it 'shows the Apply 1 has closed banner' do
    visit switch_cycle_schedule_path
    page.choose 'Apply 1 deadline has passed'
    click_button 'Update point in recruitment cycle'
    visit root_path

    expect(page).to have_text("If you’re applying for the first time since applications opened in #{CycleTimetable.find_opens.to_s(:month_and_year)}")
  end

  it 'shows the Apply 2 has closed banner' do
    visit switch_cycle_schedule_path
    page.choose 'Apply 2 deadline has passed'
    click_button 'Update point in recruitment cycle'
    visit root_path

    expect(page).to have_text("It’s no longer possible to apply for teacher training starting in the #{CycleTimetable.cycle_year_range} academic year")
  end

  it 'closes Find' do
    visit switch_cycle_schedule_path
    page.choose 'Find has closed'
    click_button 'Update point in recruitment cycle'
    visit root_path

    expect(page).to have_content('Applications are currently closed but you can get ready to apply')
  end

  it 'opens Find' do
    visit switch_cycle_schedule_path
    page.choose 'Find has reopened'
    click_button 'Update point in recruitment cycle'
    visit root_path

    expect(page).to have_text('Find courses by location or by training provider')
  end
end
