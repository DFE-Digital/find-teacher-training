module FiltersFeatureSpecsHelper
  def results_page
    @results_page ||= PageObjects::Page::Results.new
  end

  def when_i_visit_the_results_page
    stub_subjects
    stub_courses(query: results_page_parameters, course_count: 10)
    results_page.load
  end

  def and_apply_the_filters
    results_page.apply_filters_button.click
  end
end
