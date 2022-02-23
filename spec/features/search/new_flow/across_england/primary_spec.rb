require 'rails_helper'

RSpec.feature 'Searching across England' do
  include StubbedRequests::SubjectAreas
  include StubbedRequests::Courses
  include StubbedRequests::Subjects

  before do
    stub_subjects
    stub_courses_request
    stub_subject_areas
  end

  scenario 'Candidate searches for primary courses across England' do
    when_i_visit_the_start_page
    and_i_select_the_across_england_radio_button
    and_i_click_continue
    then_i_should_see_the_age_groups_form
    and_the_correct_age_group_form_page_url_and_query_params_are_present

    when_i_click_back
    then_i_should_see_the_start_page
    and_the_across_england_radio_button_is_selected

    when_i_click_continue
    then_i_should_see_the_age_groups_form

    when_i_click_continue
    i_should_see_an_age_group_validation_error

    when_i_select_the_primary_radio_button
    and_i_click_continue
    then_i_should_see_the_subjects_form
    and_the_correct_subjects_form_page_url_and_query_params_are_present

    when_i_click_back
    then_i_should_see_the_age_groups_form
    and_age_group_radio_selected

    when_i_click_continue
    then_i_should_see_the_subjects_form

    when_i_click_find_courses
    then_i_should_see_a_subjects_validation_error

    when_i_select_the_primary_subject_textbox
    and_i_click_find_courses
    then_i_should_see_the_results_page
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

  def when_i_click_back
    click_link 'Back'
  end

  def when_i_click_continue
    and_i_click_continue
  end

  def then_i_should_see_the_start_page
    expect(page).to have_content('Find courses by location or by training provider')
  end

  def and_the_across_england_radio_button_is_selected
    expect(find_field('Across England')).to be_checked
  end

  def and_age_group_radio_selected
    expect(find_field('Primary')).to be_checked
  end

  def then_i_should_see_the_age_groups_form
    expect(page).to have_content(I18n.t('age_groups.title'))
  end

  def and_the_correct_age_group_form_page_url_and_query_params_are_present
    URI(current_url).then do |uri|
      expect(uri.path).to eq('/age-groups')
      expect(uri.query).to eq('l=2')
    end
  end

  def and_the_correct_subjects_form_page_url_and_query_params_are_present
    URI(current_url).then do |uri|
      expect(uri.path).to eq('/subjects')
      expect(uri.query).to eq('age_group=primary&fulltime=false&hasvacancies=true&l=2&parttime=false&qualifications%5B%5D=QtsOnly&qualifications%5B%5D=PgdePgceWithQts&qualifications%5B%5D=Other&senCourses=false')
    end
  end

  def i_should_see_an_age_group_validation_error
    expect(page).to have_content('Select an age group')
  end

  def when_i_select_the_primary_radio_button
    choose 'Primary'
  end

  def then_i_should_see_the_subjects_form
    expect(page).to have_content('Primary courses with subject specialisms')
  end

  def and_i_click_find_courses
    click_button 'Find courses'
  end

  def when_i_click_find_courses
    and_i_click_find_courses
  end

  def then_i_should_see_a_subjects_validation_error
    expect(page).to have_content('Select at least one subject')
  end

  def when_i_select_the_primary_subject_textbox
    check 'Primary'
  end

  def then_i_should_see_the_results_page
    expect(page).to have_current_path('/results?age_group=primary&fulltime=false&hasvacancies=true&l=2&parttime=false&qualifications%5B%5D=QtsOnly&qualifications%5B%5D=PgdePgceWithQts&qualifications%5B%5D=Other&senCourses=false&subject_codes%5B%5D=00')
  end

  def stub_courses_request
    stub_courses(query: results_page_parameters({ 'filter[subjects]' => '00' }), course_count: 10)
  end
end
