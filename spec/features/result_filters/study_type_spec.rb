require 'rails_helper'

RSpec.feature 'Results page new study type filter' do
  include StubbedRequests::Courses
  include StubbedRequests::Subjects

  let(:results_page) { PageObjects::Page::Results.new }
  let(:base_parameters) { results_page_parameters }

  before do
    stub_subjects
    stub_courses(query: base_parameters, course_count: 10)
  end

  describe 'viewing results without explicitly de-selecting a filter' do
    it 'show courses with all study types selected' do
      results_page.load

      expect(results_page.study_type_filter.legend.text).to eq('Study type')
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

        results_page.load
        results_page.study_type_filter.parttime_checkbox.uncheck
        results_page.apply_filters_button.click
      end

      it 'list the filtered courses' do
        expect(results_page.study_type_filter.legend.text).to eq('Study type')
        expect(results_page.study_type_filter.parttime_checkbox.checked?).to be(false)
        expect(results_page.study_type_filter.fulltime_checkbox.checked?).to be(true)
      end

      it 'retains the query parameters' do
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
    end

    context 'show part time courses only' do
      before do
        stub_courses(
          query: base_parameters.merge(
            'filter[study_type]' => 'part_time',
          ),
          course_count: 10,
        )

        results_page.load
        results_page.study_type_filter.fulltime_checkbox.uncheck
        results_page.apply_filters_button.click
      end

      it 'list the filtered courses' do
        expect(results_page.study_type_filter.legend.text).to eq('Study type')
        expect(results_page.study_type_filter.parttime_checkbox.checked?).to be(true)
        expect(results_page.study_type_filter.fulltime_checkbox.checked?).to be(false)
      end

      it 'retains the query parameters' do
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

    context 'show full time and part time courses (default behaviour)' do
      before do
        stub_courses(
          query: base_parameters.merge(
            'filter[study_type]' => 'part_time,full_time',
          ),
          course_count: 10,
        )

        results_page.load
        results_page.study_type_filter.fulltime_checkbox.uncheck
        results_page.study_type_filter.parttime_checkbox.uncheck
        results_page.apply_filters_button.click
      end

      it 'still lists full time and part time courses when both are deselected' do
        expect(results_page.study_type_filter.legend.text).to eq('Study type')
        expect(results_page.study_type_filter.parttime_checkbox.checked?).to be(true)
        expect(results_page.study_type_filter.fulltime_checkbox.checked?).to be(true)
      end

      it 'retains the query parameters' do
        expect_page_to_be_displayed_with_query(
          page: results_page,
          expected_query_params: {
            'hasvacancies' => 'true',
            'degree_required' => 'show_all_courses',
            'qualifications' => %w[QtsOnly PgdePgceWithQts Other],
          },
        )
      end
    end
  end
end
