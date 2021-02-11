require 'rails_helper'

RSpec.feature 'Results page new vacancies filter' do
  include StubbedRequests::Courses
  include StubbedRequests::Subjects

  let(:results_page) { PageObjects::Page::ResultsWithNewFilters.new }
  let(:base_parameters) { results_page_parameters }

  before do
    activate_feature(:new_filters)

    stub_subjects
    stub_courses(query: base_parameters, course_count: 10)
  end

  describe 'viewing results without explicitly selecting a filter' do
    it 'show courses with or without vacancies' do
      results_page.load

      expect(results_page.vacancies_filter.subheading.text).to eq('Vacancies')
      expect(results_page.vacancies_filter.checkbox.checked?).to be(false)
      expect(results_page.courses.count).to eq(10)
    end
  end

  describe 'applying the filter' do
    before do
      stub_courses(
        query: base_parameters.merge(
          'filter[has_vacancies]' => 'true',
          'filter[study_type]' => 'full_time,part_time',
        ),
        course_count: 10,
      )
    end

    context 'show courses with vacancies only' do
      it 'list the filtered courses' do
        results_page.load

        results_page.vacancies_filter.checkbox.check
        results_page.apply_filters_button.click

        expect(results_page.vacancies_filter.subheading.text).to eq('Vacancies')
        expect(results_page.vacancies_filter.checkbox.checked?).to be(true)
        expect(results_page.courses.count).to eq(10)
      end
    end
  end
end
