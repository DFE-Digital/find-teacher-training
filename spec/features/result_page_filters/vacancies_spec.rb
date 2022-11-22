require 'rails_helper'

RSpec.feature 'Results page new vacancies filter' do
  include StubbedRequests::Courses
  include StubbedRequests::Subjects
  include FiltersFeatureSpecsHelper

  scenario 'Candidate applies vacancies filter on results page' do
    when_i_visit_the_results_page
    then_i_see_the_vacancies_checkbox_is_selected

    when_i_unselect_the_vacancies_checkbox
    and_apply_the_filters
    then_i_see_that_the_vacancies_checkbox_is_still_unselected
    and_the_vacancies_query_parameters_are_retained
  end

  def then_i_see_the_vacancies_checkbox_is_selected
    expect(results_page.vacancies_filter.legend.text).to eq('Vacancies filter')
    expect(results_page.vacancies_filter.checkbox.checked?).to be(true)
  end

  def when_i_unselect_the_vacancies_checkbox
    base_params = results_page_parameters
    base_params.delete('filter[has_vacancies]')

    stub_courses(
      query: base_params.merge('filter[study_type]' => 'full_time,part_time'),
      course_count: 10,
    )

    results_page.vacancies_filter.checkbox.uncheck
  end

  def then_i_see_that_the_vacancies_checkbox_is_still_unselected
    expect(results_page.vacancies_filter.checkbox.checked?).to be(false)
  end

  def and_the_vacancies_query_parameters_are_retained
    expect_page_to_be_displayed_with_query(
      page: results_page,
      expected_query_params: {
        'fulltime' => 'true',
        'parttime' => 'true',
        'hasvacancies' => 'false',
        'degree_required' => 'show_all_courses',
        'qualifications' => %w[QtsOnly PgdePgceWithQts Other],
      },
    )
  end
end
