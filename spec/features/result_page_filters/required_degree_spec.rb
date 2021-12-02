require 'rails_helper'

RSpec.feature 'Required degree filter' do
  include StubbedRequests::Courses
  include StubbedRequests::Subjects
  include FiltersFeatureSpecsHelper

  scenario 'Candidate applies required degree filters on results page' do
    when_i_visit_the_results_page
    then_i_see_the_two_one_or_first_degree_radio_checked

    when_i_select_the_two_two_degree_radio
    and_apply_the_filters
    then_i_see_that_the_two_two_degree_radio_is_selected
    and_the_two_two_degree_query_parameters_are_retained

    when_i_select_the_third_degree_radio
    and_apply_the_filters
    then_i_see_that_the_third_degree_radio_is_selected
    and_the_third_degree_query_parameters_are_retained

    when_i_select_the_pass_degree_radio
    and_apply_the_filters
    then_i_see_that_the_pass_degree_radio_is_selected
    and_the_pass_degree_query_parameters_are_retained
  end

  def then_i_see_the_two_one_or_first_degree_radio_checked
    expect(results_page.degree_required_filter.legend.text).to eq('Degree grade accepted')
    expect(results_page.degree_required_filter.show_all_courses_radio.checked?).to be(true)
  end

  def when_i_select_the_two_two_degree_radio
    stub_courses(
      query: results_page_parameters.merge(
        'filter[degree_grade]' => 'two_two,third_class,not_required',
        'filter[study_type]' => 'full_time,part_time',
      ),
      course_count: 10,
    )

    results_page.degree_required_filter.two_two_radio.choose
  end

  def then_i_see_that_the_two_two_degree_radio_is_selected
    expect(results_page.degree_required_filter.legend.text).to eq('Degree grade accepted')
    expect(results_page.degree_required_filter.two_two_radio.checked?).to be(true)
  end

  def and_the_two_two_degree_query_parameters_are_retained
    expect_page_to_be_displayed_with_query(
      page: results_page,
      expected_query_params: {
        'fulltime' => 'true',
        'parttime' => 'true',
        'hasvacancies' => 'true',
        'degree_required' => 'two_two',
        'qualifications' => %w[QtsOnly PgdePgceWithQts Other],
      },
    )
  end

  def when_i_select_the_third_degree_radio
    stub_courses(
      query: results_page_parameters.merge(
        'filter[degree_grade]' => 'third_class,not_required',
        'filter[study_type]' => 'full_time,part_time',
      ),
      course_count: 10,
    )

    results_page.degree_required_filter.third_class_radio.choose
  end

  def then_i_see_that_the_third_degree_radio_is_selected
    expect(results_page.degree_required_filter.legend.text).to eq('Degree grade accepted')
    expect(results_page.degree_required_filter.third_class_radio.checked?).to be(true)
  end

  def and_the_third_degree_query_parameters_are_retained
    expect_page_to_be_displayed_with_query(
      page: results_page,
      expected_query_params: {
        'fulltime' => 'true',
        'parttime' => 'true',
        'hasvacancies' => 'true',
        'degree_required' => 'third_class',
        'qualifications' => %w[QtsOnly PgdePgceWithQts Other],
      },
    )
  end

  def when_i_select_the_pass_degree_radio
    stub_courses(
      query: results_page_parameters.merge(
        'filter[degree_grade]' => 'not_required',
        'filter[study_type]' => 'full_time,part_time',
      ),
      course_count: 10,
    )

    results_page.degree_required_filter.not_required_radio.choose
  end

  def then_i_see_that_the_pass_degree_radio_is_selected
    expect(results_page.degree_required_filter.legend.text).to eq('Degree grade accepted')
    expect(results_page.degree_required_filter.not_required_radio.checked?).to be(true)
  end

  def and_the_pass_degree_query_parameters_are_retained
    expect_page_to_be_displayed_with_query(
      page: results_page,
      expected_query_params: {
        'fulltime' => 'true',
        'parttime' => 'true',
        'hasvacancies' => 'true',
        'degree_required' => 'not_required',
        'qualifications' => %w[QtsOnly PgdePgceWithQts Other],
      },
    )
  end
end
