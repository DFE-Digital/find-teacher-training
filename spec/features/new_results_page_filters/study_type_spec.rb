require 'rails_helper'

RSpec.feature 'Results page new study type filter' do
  include StubbedRequests::Courses
  include StubbedRequests::Subjects

  let(:results_page) { PageObjects::Page::ResultsWithNewFilters.new }
  let(:base_parameters) { results_page_parameters }

  before do
    activate_feature(:new_filters)

    stub_subjects
    stub_courses(query: base_parameters, course_count: 10)
  end

  describe 'viewing results without explicitly de-selecting a filter' do
    it 'show courses with all study types selected' do
      results_page.load

      expect(results_page.study_type_filter.subheading.text).to eq('Study type')
      expect(results_page.study_type_filter.parttime_checkbox.checked?).to be(true)
      expect(results_page.study_type_filter.fulltime_checkbox.checked?).to be(true)
    end
  end

  describe 'applying the filters' do
    context 'show full time courses only' do
      before do
        stub_courses(
          query: base_parameters.merge(
            'filter[study_type]' => 'full_time',
          ),
          course_count: 10,
        )
      end

      it 'list the filtered courses' do
        results_page.load

        results_page.study_type_filter.parttime_checkbox.uncheck
        results_page.apply_filters_button.click

        expect(results_page.study_type_filter.subheading.text).to eq('Study type')
        expect(results_page.study_type_filter.parttime_checkbox.checked?).to be(false)
        expect(results_page.study_type_filter.fulltime_checkbox.checked?).to be(true)
      end
    end

    context 'show part time courses only' do
      before do
        stub_courses(
          query: base_parameters.merge(
            'filter[study_type]' => 'part_time',
          ),
          course_count: 10,
        )
      end

      it 'list the filtered courses' do
        results_page.load

        results_page.study_type_filter.fulltime_checkbox.uncheck
        results_page.apply_filters_button.click

        expect(results_page.study_type_filter.subheading.text).to eq('Study type')
        expect(results_page.study_type_filter.parttime_checkbox.checked?).to be(true)
        expect(results_page.study_type_filter.fulltime_checkbox.checked?).to be(false)
      end
    end

    context 'show full time and part time courses (default behaviour)' do
      before do
        stub_courses(
          query: base_parameters.merge(
            'filter[study_type]' => 'part_time,full_time',
          ),
          course_count: 10,
        )
      end

      it 'still lists full time and part time courses when both are deselected' do
        results_page.load

        results_page.study_type_filter.fulltime_checkbox.uncheck
        results_page.study_type_filter.parttime_checkbox.uncheck
        results_page.apply_filters_button.click

        expect(results_page.study_type_filter.subheading.text).to eq('Study type')
        expect(results_page.study_type_filter.parttime_checkbox.checked?).to be(true)
        expect(results_page.study_type_filter.fulltime_checkbox.checked?).to be(true)
      end
    end
  end
end
