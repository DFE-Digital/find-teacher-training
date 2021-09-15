require 'rails_helper'

RSpec.feature 'Results page required degree filter' do
  include StubbedRequests::Courses
  include StubbedRequests::Subjects

  let(:results_page) { PageObjects::Page::Results.new }
  let(:base_parameters) { results_page_parameters }

  before do
    stub_subjects
    stub_courses(query: base_parameters, course_count: 10)
  end

  describe 'viewing results without explicitly selecting a filter' do
    it 'shows all courses' do
      results_page.load

      expect(results_page.degree_required_filter.legend.text).to eq('Degree grade accepted')
      expect(results_page.degree_required_filter.show_all_courses_radio.checked?).to be(true)
    end
  end

  describe 'applying the filters' do
    context 'shows only courses with a minimum requirement of a 2:2 degree' do
      before do
        stub_courses(
          query: base_parameters.merge(
            'filter[degree_grade]' => 'two_two,third_class,not_required',
            'filter[study_type]' => 'full_time,part_time',
          ),
          course_count: 10,
        )

        results_page.load
        results_page.degree_required_filter.two_two_radio.choose
        results_page.apply_filters_button.click
      end

      it 'list the filtered courses' do
        expect(results_page.degree_required_filter.legend.text).to eq('Degree grade accepted')
        expect(results_page.degree_required_filter.two_two_radio.checked?).to be(true)
      end

      it 'retains the query parameters' do
        expect_page_to_be_displayed_with_query(
          page: results_page,
          expected_query_params: {
            'fulltime' => 'true',
            'parttime' => 'true',
            'hasvacancies' => 'true',
            'degree_required' => 'two_two',
            'qualifications' => %w[QtsOnly PgdePgceWithQts Other],
          },
        )
      end
    end

    context 'shows only courses with a minimum requirement of a third class degree' do
      before do
        stub_courses(
          query: base_parameters.merge(
            'filter[degree_grade]' => 'third_class,not_required',
            'filter[study_type]' => 'full_time,part_time',
          ),
          course_count: 10,
        )

        results_page.load
        results_page.degree_required_filter.third_class_radio.choose
        results_page.apply_filters_button.click
      end

      it 'list the filtered courses' do
        expect(results_page.degree_required_filter.legend.text).to eq('Degree grade accepted')
        expect(results_page.degree_required_filter.third_class_radio.checked?).to be(true)
      end

      it 'retains the query parameters' do
        expect_page_to_be_displayed_with_query(
          page: results_page,
          expected_query_params: {
            'fulltime' => 'true',
            'parttime' => 'true',
            'hasvacancies' => 'true',
            'degree_required' => 'third_class',
            'qualifications' => %w[QtsOnly PgdePgceWithQts Other],
          },
        )
      end
    end

    context 'shows only courses with no minimum degree requirement' do
      before do
        stub_courses(
          query: base_parameters.merge(
            'filter[degree_grade]' => 'not_required',
            'filter[study_type]' => 'full_time,part_time',
          ),
          course_count: 10,
        )

        results_page.load
        results_page.degree_required_filter.not_required_radio.choose
        results_page.apply_filters_button.click
      end

      it 'list the filtered courses' do
        expect(results_page.degree_required_filter.legend.text).to eq('Degree grade accepted')
        expect(results_page.degree_required_filter.not_required_radio.checked?).to be(true)
      end

      it 'retains the query parameters' do
        expect_page_to_be_displayed_with_query(
          page: results_page,
          expected_query_params: {
            'fulltime' => 'true',
            'parttime' => 'true',
            'hasvacancies' => 'true',
            'degree_required' => 'not_required',
            'qualifications' => %w[QtsOnly PgdePgceWithQts Other],
          },
        )
      end
    end
  end
end
