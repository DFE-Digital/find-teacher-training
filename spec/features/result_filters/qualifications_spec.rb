require 'rails_helper'

RSpec.feature 'Results page new qualifications filter' do
  include StubbedRequests::Courses
  include StubbedRequests::Subjects

  let(:results_page) { PageObjects::Page::Results.new }
  let(:base_parameters) { results_page_parameters }

  before do
    stub_subjects
    stub_courses(query: base_parameters, course_count: 10)
  end

  describe 'viewing results without explicitly de-selecting a filter' do
    it 'show courses with all qualification types selected' do
      results_page.load

      expect(results_page.qualifications_filter.legend.text).to eq('Qualifications')
      expect(results_page.qualifications_filter.qts_checkbox.checked?).to be(true)
      expect(results_page.qualifications_filter.pgce_checkbox.checked?).to be(true)
      expect(results_page.qualifications_filter.further_education_checkbox.checked?).to be(true)
    end
  end

  describe 'applying the filters' do
    context 'show QTS courses only' do
      before do
        stub_courses(
          query: base_parameters.merge(
            'filter[qualification]' => 'qts',
            'filter[study_type]' => 'full_time,part_time',
          ),
          course_count: 10,
        )

        results_page.load
        results_page.qualifications_filter.pgce_checkbox.uncheck
        results_page.qualifications_filter.further_education_checkbox.uncheck
        results_page.apply_filters_button.click
      end

      it 'list the filtered courses' do
        expect(results_page.qualifications_filter.legend.text).to eq('Qualifications')
        expect(results_page.qualifications_filter.qts_checkbox.checked?).to be(true)
        expect(results_page.qualifications_filter.pgce_checkbox.checked?).to be(false)
        expect(results_page.qualifications_filter.further_education_checkbox.checked?).to be(false)
      end

      it 'retains the query parameters' do
        expect_page_to_be_displayed_with_query(
          page: results_page,
          expected_query_params: {
            'fulltime' => 'true',
            'parttime' => 'true',
            'hasvacancies' => 'true',
            'degree_required' => '1',
            'qualifications' => %w[QtsOnly],
          },
        )
      end
    end

    context 'show PGCE (or PGDE) with QTS courses only' do
      before do
        stub_courses(
          query: base_parameters.merge(
            'filter[qualification]' => 'pgce_with_qts,pgde_with_qts',
            'filter[study_type]' => 'full_time,part_time',
          ),
          course_count: 10,
        )

        results_page.load
        results_page.qualifications_filter.further_education_checkbox.uncheck
        results_page.qualifications_filter.qts_checkbox.uncheck
        results_page.apply_filters_button.click
      end

      it 'lists the filtered courses' do
        expect(results_page.qualifications_filter.legend.text).to eq('Qualifications')
        expect(results_page.qualifications_filter.pgce_checkbox.checked?).to be(true)
        expect(results_page.qualifications_filter.qts_checkbox.checked?).to be(false)
        expect(results_page.qualifications_filter.further_education_checkbox.checked?).to be(false)
      end

      it 'retains the query parameters' do
        expect_page_to_be_displayed_with_query(
          page: results_page,
          expected_query_params: {
            'fulltime' => 'true',
            'parttime' => 'true',
            'hasvacancies' => 'true',
            'degree_required' => '1',
            'qualifications' => %w[PgdePgceWithQts],
          },
        )
      end
    end

    context 'show further education (PGCE or PGDE without QTS) courses only' do
      before do
        stub_courses(
          query: base_parameters.merge(
            'filter[qualification]' => 'pgce,pgde',
            'filter[study_type]' => 'full_time,part_time',
          ),
          course_count: 10,
        )
      end

      it 'list the filtered courses' do
        results_page.load

        results_page.qualifications_filter.pgce_checkbox.uncheck
        results_page.qualifications_filter.qts_checkbox.uncheck
        results_page.apply_filters_button.click

        expect(results_page.qualifications_filter.legend.text).to eq('Qualifications')
        expect(results_page.qualifications_filter.further_education_checkbox.checked?).to be(true)
        expect(results_page.qualifications_filter.pgce_checkbox.checked?).to be(false)
        expect(results_page.qualifications_filter.qts_checkbox.checked?).to be(false)
      end
    end
  end
end
