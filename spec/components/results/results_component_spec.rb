require 'rails_helper'

describe Results::ResultsComponent, type: :component do
  include StubbedRequests::Courses

  it 'renders a "No courses found" message when there are no results' do
    results_view = instance_double(
      ResultsView,
      country: 'Scotland',
      devolved_nation?: true,
      subjects: [],
      total_pages: 0,
      number_of_courses_string: 'No courses',
      no_results_found?: true,
      suggested_search_visible?: false,
      has_results?: false,
      location_filter?: true,
      provider_filter?: false,
      location_search: 'London',
      filter_params_for: '/',
    )

    # courses = instance_double(
    #   JsonApiClient::ResultSet,
    #   current_page: 0,
    #   limit_value: 0,
    # )

    stub_courses(query: {}, course_count: 0)
    courses = Course.where(recruitment_cycle_year: RecruitmentCycle.current_year).all
    component = render_inline(
      described_class.new(results: results_view, courses: courses),
    )

    expect(component.text).to include('No courses found')
  end
end
