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

  scenario 'Candidate searches for further education courses across England' do
    given_that_the_new_search_flow_feature_flag_is_enabled
    when_i_visit_the_start_page
    and_i_select_the_across_england_radio_button
    and_i_click_continue
    then_i_should_see_the_age_groups_form
    and_the_correct_age_group_form_page_url_and_query_params_are_present

    when_i_select_the_further_education_radio_button
    and_i_click_continue
    then_i_should_see_the_results_page
  end

  def given_that_the_new_search_flow_feature_flag_is_enabled
    allow(FeatureFlag).to receive(:active?).and_call_original
    allow(FeatureFlag).to receive(:active?).with(:new_search_flow).and_return(true)
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

  def then_i_should_see_the_age_groups_form
    expect(page).to have_content('Which age group do you want to teach?')
  end

  def and_the_correct_age_group_form_page_url_and_query_params_are_present
    URI(current_url).then do |uri|
      expect(uri.path).to eq('/age-groups')
      expect(uri.query).to eq('l=2')
    end
  end

  def when_i_select_the_further_education_radio_button
    choose 'Further education'
  end

  def then_i_should_see_the_results_page
    expect(page).to have_current_path('/results?age_group=further_education&l=2&subject_codes%5B%5D=41')
  end

  def stub_courses_request
    stub_courses(query: results_page_parameters({ 'filter[subjects]' => '41' }), course_count: 10)
  end
end
