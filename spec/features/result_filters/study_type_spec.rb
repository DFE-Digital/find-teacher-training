require 'rails_helper'

describe 'Study type filter', type: :feature do
  let(:filter_page) { PageObjects::Page::ResultFilters::StudyType.new }
  let(:results_page) { PageObjects::Page::Results.new }
  let(:base_parameters) { results_page_parameters }

  before do
    stub_subjects_request
  end

  describe 'Study type filter page' do
    before { filter_page.load }

    it 'has the correct title and heading' do
      expect(page.title).to have_content('Filter by study type')
      expect(page).to have_content('Study type')
    end

    describe 'Navigating to the page with currently selected filters' do
      it 'Preselects with fulltime' do
        filter_page.load(query: { fulltime: 'true' })
        expect(filter_page.full_time.checked?).to eq(true)
        expect(filter_page.part_time.checked?).to eq(false)
      end

      it 'Preselects with parttime' do
        filter_page.load(query: { parttime: 'true' })
        expect(filter_page.full_time.checked?).to eq(false)
        expect(filter_page.part_time.checked?).to eq(true)
      end

      it 'Preselects all' do
        filter_page.load
        expect(filter_page.full_time.checked?).to eq(true)
        expect(filter_page.part_time.checked?).to eq(true)
      end
    end

    describe 'back link' do
      before do
        stub_request(:get, courses_url)
          .with(query: base_parameters)
          .to_return(
            body: File.new('spec/fixtures/api_responses/ten_courses.json'),
            headers: { "Content-Type": 'application/vnd.api+json; charset=utf-8' },
          )
      end

      it 'navigates back to the results page' do
        filter_page.load(query: { test: 'params' })
        filter_page.back_link.click

        expect_page_to_be_displayed_with_query(
          page: results_page,
          expected_query_params: {
            'fulltime' => 'false',
            'hasvacancies' => 'false',
            'parttime' => 'false',
            'qualifications' => %w[QtsOnly PgdePgceWithQts Other],
            'senCourses' => 'false',
            'test' => 'params',
          },
        )
      end
    end

    describe 'Validation' do
      it 'Displays an error if neither option is selected' do
        filter_page.load

        filter_page.part_time.click
        filter_page.full_time.click

        filter_page.find_courses.click

        expect(filter_page).to have_error
      end
    end
  end

  describe 'viewing results without explicitly selecting a filter' do
    before do
      stub_request(:get, courses_url)
        .with(query: base_parameters)
        .to_return(
          body: File.new('spec/fixtures/api_responses/ten_courses.json'),
          headers: { "Content-Type": 'application/vnd.api+json; charset=utf-8' },
        )
    end

    it 'lists only courses with both study types' do
      results_page.load

      expect(results_page.study_type_filter).to have_parttime
      expect(results_page.study_type_filter).to have_fulltime

      expect(results_page.courses.count).to eq(10)
    end
  end

  describe 'applying a filter' do
    before do
      stub_request(:get, courses_url)
        .with(query: base_parameters)
        .to_return(
          body: File.new('spec/fixtures/api_responses/ten_courses.json'),
          headers: { "Content-Type": 'application/vnd.api+json; charset=utf-8' },
        )
    end

    context 'deselecting full time' do
      before do
        stub_request(:get, courses_url)
          .with(query: base_parameters.merge('filter[study_type]' => 'part_time'))
          .to_return(
            body: File.new('spec/fixtures/api_responses/ten_courses.json'),
            headers: { "Content-Type": 'application/vnd.api+json; charset=utf-8' },
          )
      end

      it 'list the courses' do
        results_page.load
        results_page.study_type_filter.link.click

        expect(filter_page.heading.text).to eq('Study type')
        filter_page.full_time.click
        filter_page.find_courses.click

        expect(results_page.heading.text).to eq('Teacher training courses')
        expect(results_page.study_type_filter).to have_parttime

        expect(results_page.courses.count).to eq(10)
      end
    end

    context 'deselecting part time' do
      before do
        stub_request(:get, courses_url)
          .with(query: base_parameters.merge('filter[study_type]' => 'full_time'))
          .to_return(
            body: File.new('spec/fixtures/api_responses/ten_courses.json'),
            headers: { "Content-Type": 'application/vnd.api+json; charset=utf-8' },
          )
      end

      it 'list the courses' do
        results_page.load
        results_page.study_type_filter.link.click

        expect(filter_page.heading.text).to eq('Study type')
        filter_page.part_time.click
        filter_page.find_courses.click

        expect(results_page.heading.text).to eq('Teacher training courses')
        expect(results_page.study_type_filter).to have_fulltime

        expect(results_page.courses.count).to eq(10)
      end
    end

    context 'deselecting full time and part time' do
      it 'displays an error' do
        results_page.load
        results_page.study_type_filter.link.click

        expect(filter_page.heading.text).to eq('Study type')
        filter_page.part_time.click
        filter_page.full_time.click
        filter_page.find_courses.click

        expect(filter_page).to have_error
      end
    end

    context 'submitting without deselection' do
      before do
        stub_request(:get, courses_url)
          .with(query: base_parameters.merge('filter[study_type]' => 'full_time,part_time'))
          .to_return(
            body: File.new('spec/fixtures/api_responses/ten_courses.json'),
            headers: { "Content-Type": 'application/vnd.api+json; charset=utf-8' },
          )
      end

      it 'list the courses' do
        results_page.load
        results_page.study_type_filter.link.click

        expect(filter_page.heading.text).to eq('Study type')

        filter_page.find_courses.click

        expect(filter_page.heading.text).to eq('Teacher training courses')

        expect(results_page.study_type_filter).to have_fulltime

        expect(results_page.study_type_filter).to have_parttime

        expect(results_page.courses.count).to eq(10)
      end
    end
  end
end
