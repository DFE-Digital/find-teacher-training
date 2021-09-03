require 'rails_helper'

RSpec.feature 'Results page visa filter' do
  include StubbedRequests::Courses
  include StubbedRequests::Subjects

  let(:results_page) { PageObjects::Page::Results.new }
  let(:base_parameters) { results_page_parameters }

  before do
    stub_subjects
    stub_courses(query: base_parameters, course_count: 10)
  end

  describe 'viewing results without explicitly selecting a filter' do
    it 'show courses with or without Visa sponsorship' do
      results_page.load

      expect(results_page.visa_filter.legend.text).to eq('Visa sponsorship')
      expect(results_page.visa_filter.checkbox.checked?).to be(false)
    end
  end

  describe 'applying the filter' do
    before do
      stub_courses(
        query: base_parameters.merge(
          'filter[can_sponsor_visa]' => 'true',
          'filter[study_type]' => 'full_time,part_time',
        ),
        course_count: 10,
      )

      results_page.load
      results_page.visa_filter.checkbox.check
      results_page.apply_filters_button.click
    end

    context 'selecting courses with visa sponsorship' do
      it 'list the filtered courses' do
        expect(results_page.visa_filter.legend.text).to eq('Visa sponsorship')
        expect(results_page.visa_filter.checkbox.checked?).to be(true)
      end

      it 'retains the query parameters' do
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
  end
end
