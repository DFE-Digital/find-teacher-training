require 'rails_helper'

RSpec.feature 'Study type filter' do
  include StubbedRequests::Courses
  include StubbedRequests::Subjects
  include FiltersFeatureSpecsHelper

  scenario 'Candidate applies study type filters on results page' do
    when_i_visit_the_results_page
    then_i_see_both_study_type_checkboxes_are_selected

    when_i_unselect_the_part_time_study_checkbox
    and_apply_the_filters
    then_i_see_that_the_full_time_study_checkbox_is_still_selected
    and_the_part_time_study_checkbox_is_unselected
    and_the_full_time_study_query_parameters_are_retained

    when_i_unselect_the_full_time_study_checkbox
    and_i_select_the_part_time_study_checkbox
    and_apply_the_filters
    then_i_see_that_the_part_time_study_checkbox_is_still_selected
    and_the_full_time_study_checkbox_is_unselected
    and_the_part_time_study_query_parameters_are_retained
  end

  def then_i_see_both_study_type_checkboxes_are_selected
    expect(results_page.study_type_filter.legend.text).to eq('Study type')
    expect(results_page.study_type_filter.parttime_checkbox.checked?).to be(true)
    expect(results_page.study_type_filter.fulltime_checkbox.checked?).to be(true)
  end

  def when_i_unselect_the_part_time_study_checkbox
    stub_courses(
      query: results_page_parameters.merge(
        'filter[study_type]' => 'full_time',
      ),
      course_count: 10,
    )

    results_page.study_type_filter.parttime_checkbox.uncheck
  end

  def then_i_see_that_the_full_time_study_checkbox_is_still_selected
    expect(results_page.study_type_filter.fulltime_checkbox.checked?).to be(true)
  end

  def and_the_part_time_study_checkbox_is_unselected
    expect(results_page.study_type_filter.parttime_checkbox.checked?).to be(false)
  end

  def and_the_full_time_study_query_parameters_are_retained
    expect_page_to_be_displayed_with_query(
      page: results_page,
      expected_query_params: {
        'fulltime' => 'true',
        'hasvacancies' => 'true',
        'degree_required' => 'show_all_courses',
        'qualifications' => %w[QtsOnly PgdePgceWithQts Other],
      },
    )
  end

  def when_i_unselect_the_full_time_study_checkbox
    stub_courses(
      query: results_page_parameters.merge(
        'filter[study_type]' => 'part_time',
      ),
      course_count: 10,
    )

    results_page.study_type_filter.fulltime_checkbox.uncheck
  end

  def and_i_select_the_part_time_study_checkbox
    results_page.study_type_filter.parttime_checkbox.check
  end

  def then_i_see_that_the_part_time_study_checkbox_is_still_selected
    expect(results_page.study_type_filter.parttime_checkbox.checked?).to be(true)
  end

  def and_the_full_time_study_checkbox_is_unselected
    expect(results_page.study_type_filter.fulltime_checkbox.checked?).to be(false)
  end

  def and_the_part_time_study_query_parameters_are_retained
    expect_page_to_be_displayed_with_query(
      page: results_page,
      expected_query_params: {
        'parttime' => 'true',
        'hasvacancies' => 'true',
        'degree_required' => 'show_all_courses',
        'qualifications' => %w[QtsOnly PgdePgceWithQts Other],
      },
    )
  end
end
