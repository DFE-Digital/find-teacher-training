require 'rails_helper'

RSpec.feature 'Results page new funding filter' do
  include StubbedRequests::Courses
  include StubbedRequests::Subjects

  let(:results_page) { PageObjects::Page::Results.new }
  let(:base_parameters) { results_page_parameters }

  before do
    stub_subjects
    stub_courses(query: base_parameters, course_count: 10)
  end

  describe 'viewing results without explicitly de-selecting a filter' do
    it 'shows courses with or without a salary' do
      results_page.load

      expect(results_page.funding_filter.legend.text).to eq('Salary')
      expect(results_page.funding_filter.checkbox.checked?).to be(false)
    end
  end

  describe 'applying the filters' do
    context 'shows only courses with a salary only' do
      before do
        stub_courses(
          query: base_parameters.merge(
            'filter[funding]' => 'salary',
            'filter[study_type]' => 'full_time,part_time',
          ),
          course_count: 10,
        )

        results_page.load
        results_page.funding_filter.checkbox.check
        results_page.apply_filters_button.click
      end

      it 'list the filtered courses' do
        expect(results_page.funding_filter.legend.text).to eq('Salary')
        expect(results_page.funding_filter.checkbox.checked?).to be(true)
      end

      it 'retains the query parameters' do
        expect_page_to_be_displayed_with_query(
          page: results_page,
          expected_query_params: {
            'fulltime' => 'true',
            'parttime' => 'true',
            'hasvacancies' => 'true',
            'qualifications' => %w[QtsOnly PgdePgceWithQts Other],
            'degree_required' => '1',
            'funding' => '8',
          },
        )
      end
    end
  end
end
