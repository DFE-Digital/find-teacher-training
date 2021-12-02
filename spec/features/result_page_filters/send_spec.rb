require 'rails_helper'

RSpec.feature 'Results page new SEND filter' do
  include StubbedRequests::Courses
  include StubbedRequests::Subjects
  include FiltersFeatureSpecsHelper

  scenario 'Candidate applies the SEND filter' do
    when_i_visit_the_results_page
    then_i_see_that_the_send_checkbox_is_not_selected

    when_i_select_the_send_checkbox
    and_apply_the_filters
    then_i_see_that_the_send_checkbox_is_selected
    and_the_send_query_parameter_is_retained
  end

  def then_i_see_that_the_send_checkbox_is_not_selected
    expect(results_page.send_filter.legend.text).to eq('Special educational needs')
    expect(results_page.send_filter.checkbox.checked?).to be(false)
  end

  def when_i_select_the_send_checkbox
    stub_courses(
      query: results_page_parameters.merge(
        'filter[send_courses]' => 'true',
        'filter[study_type]' => 'full_time,part_time',
      ),
      course_count: 10,
    )

    results_page.send_filter.checkbox.check
  end

  def then_i_see_that_the_send_checkbox_is_selected
    expect(results_page.send_filter.checkbox.checked?).to be(true)
  end

  def and_the_send_query_parameter_is_retained
    expect_page_to_be_displayed_with_query(
      page: results_page,
      expected_query_params: {
        'fulltime' => 'true',
        'parttime' => 'true',
        'hasvacancies' => 'true',
        'degree_required' => 'show_all_courses',
        'qualifications' => %w[QtsOnly PgdePgceWithQts Other],
        'senCourses' => 'true',
      },
    )
  end
end
