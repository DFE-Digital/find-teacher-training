require 'rails_helper'

RSpec.feature 'Funding filter' do
  include StubbedRequests::Courses
  include StubbedRequests::Subjects
  include FiltersFeatureSpecsHelper

  scenario 'Candidate applies salary filter' do
    when_i_visit_the_results_page
    then_i_see_that_the_salary_checkbox_is_not_selected

    when_i_select_the_salary_checkbox
    and_apply_the_filters
    then_i_see_that_the_salary_checkbox_is_selected
    and_the_salary_query_parameter_is_retained
  end

  def then_i_see_that_the_salary_checkbox_is_not_selected
    expect(results_page.funding_filter.legend.text).to eq('Salary')
    expect(results_page.funding_filter.checkbox.checked?).to be(false)
  end

  def when_i_select_the_salary_checkbox
    stub_courses(
      query: results_page_parameters.merge(
        'filter[funding]' => 'salary',
        'filter[study_type]' => 'full_time,part_time',
      ),
      course_count: 10,
    )

    results_page.funding_filter.checkbox.check
  end

  def then_i_see_that_the_salary_checkbox_is_selected
    expect(results_page.funding_filter.checkbox.checked?).to be(true)
  end

  def and_the_salary_query_parameter_is_retained
    expect_page_to_be_displayed_with_query(
      page: results_page,
      expected_query_params: {
        'fulltime' => 'true',
        'parttime' => 'true',
        'hasvacancies' => 'true',
        'qualifications' => %w[QtsOnly PgdePgceWithQts Other],
        'degree_required' => 'show_all_courses',
        'funding' => '8',
      },
    )
  end
end
