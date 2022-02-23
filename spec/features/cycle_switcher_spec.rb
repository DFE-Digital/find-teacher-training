# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Cycle switcher', type: :feature do
  it 'Navigates to the cycle switcher' do
    visit switch_cycle_schedule_path

    expect(page).to have_text('Current point in the recruitment cycle')
  end

  it "show the 'apply 1 deadline' banner" do
    visit switch_cycle_schedule_path
    page.choose 'Mid cycle and deadlines should be displayed'
    click_button 'Update point in recruitment cycle'
    visit root_path

    expect(page).to have_text("Apply now to get on a course starting in the #{CycleTimetable.cycle_year_range} academic year")
  end

  it "shows the 'apply 2 deadline' banner" do
    visit switch_cycle_schedule_path
    page.choose 'Apply 1 deadline has passed'
    click_button 'Update point in recruitment cycle'
    visit root_path

    expect(page).to have_text("If you’re applying for the first time since applications opened in #{CycleTimetable.find_opens.to_formatted_s(:month_and_year)}")
  end

  it "shows the 'cycle has closed' banner" do
    visit switch_cycle_schedule_path
    page.choose 'Apply 2 deadline has passed'
    click_button 'Update point in recruitment cycle'
    visit root_path

    expect(page).to have_text('Courses are currently closed but you can get your application ready')
    expect(page).to have_text("Courses starting in the #{CycleTimetable.cycle_year_range} academic year are closed")
  end

  it "redirects to the 'cycle has ended' page" do
    visit switch_cycle_schedule_path
    page.choose 'Find has closed'
    click_button 'Update point in recruitment cycle'
    visit root_path

    expect(page).to have_content('Applications are currently closed but you can get ready to apply')
    expect(page).to have_current_path(cycle_has_ended_path)
  end

  it 'redirects to the start wizard' do
    visit switch_cycle_schedule_path
    page.choose 'Find has reopened'
    click_button 'Update point in recruitment cycle'
    visit root_path

    expect(page).to have_text('Find courses by location or by training provider')
    expect(page).to have_current_path(root_path)
  end
end
