require 'rails_helper'

RSpec.feature 'Editing a search' do
  include StubbedRequests::SubjectAreas
  include StubbedRequests::Courses
  include StubbedRequests::Subjects

  before do
    stub_subjects
    stub_courses_request
    stub_subject_areas
  end

  scenario 'Candidate edits their search' do
    when_i_execute_a_valid_search
    then_i_should_see_the_results_page

    when_i_change_my_search_query
    then_i_should_see_the_start_page
    and_the_across_england_radio_button_should_be_selected

    when_i_click_continue
    then_i_should_see_the_age_groups_form
    and_the_primary_radio_button_should_be_selected

    when_i_click_continue
    then_i_should_see_the_subjects_form
    and_the_primary_checkbox_should_be_selected
  end

  def when_i_execute_a_valid_search
    when_i_visit_the_start_page
    and_i_select_the_across_england_radio_button
    and_i_click_continue
    and_i_select_the_primary_radio_button
    and_i_click_continue
    and_i_select_the_primary_subject_checkbox
    and_i_click_find_courses
  end

  def when_i_visit_the_start_page
    visit root_path
  end

  def and_i_select_the_across_england_radio_button
    choose 'Across England'
  end

  def and_i_click_continue
    click_button 'Continue'
  end

  def when_i_click_continue
    and_i_click_continue
  end

  def and_age_group_radio_selected
    expect(find_field('Primary')).to be_checked
  end

  def and_i_select_the_primary_radio_button
    choose 'Primary'
  end

  def and_i_click_find_courses
    click_button 'Find courses'
  end

  def when_i_click_find_courses
    and_i_click_find_courses
  end

  def and_i_select_the_primary_subject_checkbox
    check 'Primary'
  end

  def then_i_should_see_the_results_page
    expect(page).to have_current_path('/results?age_group=primary&l=2&subject_codes%5B%5D=00')
  end

  def when_i_change_my_search_query
    click_link 'Change'
  end

  def then_i_should_see_the_start_page
    expect(page).to have_content('Find courses by location or by training provider')
  end

  def and_the_across_england_radio_button_should_be_selected
    expect(find_field('Across England')).to be_checked
  end

  def and_the_primary_radio_button_should_be_selected
    expect(find_field('Primary')).to be_checked
  end

  def then_i_should_see_the_subjects_form
    expect(page).to have_content(I18n.t('subjects.primary_title'))
  end

  def and_the_primary_checkbox_should_be_selected
    expect(find_field('Primary')).to be_checked
  end

  def stub_courses_request
    stub_courses(query: results_page_parameters({ 'filter[subjects]' => '00' }), course_count: 10)
  end

  def then_i_should_see_the_age_groups_form
    expect(page).to have_content(I18n.t('age_groups.title'))
  end
end
