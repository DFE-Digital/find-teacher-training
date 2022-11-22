require 'rails_helper'

RSpec.feature 'Visa filter' do
  include StubbedRequests::Courses
  include StubbedRequests::Subjects
  include FiltersFeatureSpecsHelper

  scenario 'Candidate applies visa filter' do
    when_i_visit_the_results_page
    then_i_see_that_the_visa_checkbox_is_unchecked

    when_i_select_the_visa_checkbox
    and_apply_the_filters
    then_i_see_that_the_visa_checkbox_is_selected
    and_the_visa_query_parameter_is_retained
  end

  def then_i_see_that_the_visa_checkbox_is_unchecked
    expect(results_page.visa_filter.legend.text).to eq('Visa sponsorship filter')
    expect(results_page.visa_filter.checkbox.checked?).to be(false)
  end

  def when_i_select_the_visa_checkbox
    stub_courses(
      query: results_page_parameters.merge(
        'filter[can_sponsor_visa]' => 'true',
        'filter[study_type]' => 'full_time,part_time',
      ),
      course_count: 10,
    )

    results_page.visa_filter.checkbox.check
  end

  def then_i_see_that_the_visa_checkbox_is_selected
    expect(results_page.visa_filter.checkbox.checked?).to be(true)
  end

  def and_the_visa_query_parameter_is_retained
    expect_page_to_be_displayed_with_query(
      page: results_page,
      expected_query_params: {
        'fulltime' => 'true',
        'parttime' => 'true',
        'hasvacancies' => 'true',
        'degree_required' => 'show_all_courses',
        'qualifications' => %w[QtsOnly PgdePgceWithQts Other],
        'can_sponsor_visa' => 'true',
      },
    )
  end
end
