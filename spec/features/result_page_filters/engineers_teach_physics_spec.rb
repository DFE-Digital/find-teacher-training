require 'rails_helper'

RSpec.feature 'Engineers teach physics' do
  include StubbedRequests::SubjectAreas
  include StubbedRequests::Courses
  include StubbedRequests::Subjects
  include FiltersFeatureSpecsHelper

  let(:location_page) { PageObjects::Page::Search::Location.new }
  let(:start_page) { PageObjects::Page::Start.new }
  let(:age_group_page) { PageObjects::Page::Search::AgeGroup.new }
  let(:subject_page) { PageObjects::Page::Search::SubjectPage.new }

  before do
    stub_subjects
    stub_subject_areas

    given_i_visit_the_start_page
    when_i_select_the_across_england_radio_button
    and_i_click_continue
    and_i_select_the_secondary_radio_button
    and_i_click_continue
  end

  scenario 'Candidate searches for physics subject' do
    stub_courses_request('F3')
    and_i_select_the_secondary_subject('Physics')
    and_i_click_find_courses
    then_i_see_that_the_etp_checkbox_is_unchecked
  end

  scenario 'Candidate searches for any other subject' do
    stub_courses_request('W1')
    and_i_select_the_secondary_subject('Art and design')
    and_i_click_find_courses
    then_i_dont_see_the_etp_checkbox
  end

  def given_i_visit_the_start_page
    start_page.load
  end

  def when_i_select_the_across_england_radio_button
    location_page.across_england.choose
  end

  def and_i_click_continue
    click_button 'Continue'
  end

  def and_i_select_the_secondary_radio_button
    age_group_page.secondary.choose
  end

  def and_i_select_the_secondary_subject(subject)
    check subject
  end

  def and_i_click_find_courses
    subject_page.find_courses.click
  end

  def stub_courses_request(subject)
    stub_courses(query: results_page_parameters({ 'filter[subjects]' => subject }), course_count: 10)
  end

  def then_i_see_that_the_etp_checkbox_is_unchecked
    expect(results_page.engineers_teach_physics_filter.legend.text).to eq('Engineers teach physics')
    expect(results_page.engineers_teach_physics_filter.checkbox.checked?).to be(false)
    expect(results_page).to have_text('Only show Engineers teach physics courses')
  end

  def then_i_dont_see_the_etp_checkbox
    expect(results_page).not_to have_text('Only show Engineers teach physics courses')
  end
end
