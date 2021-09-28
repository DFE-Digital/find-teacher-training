require 'rails_helper'

describe 'results', type: :feature do
  include StubbedRequests::Courses
  include StubbedRequests::Subjects
  include ActiveJob::TestHelper

  let(:results_page) { PageObjects::Page::Results.new }
  let(:sort) { 'provider.provider_name,name' }
  let(:params) { nil }
  let(:base_parameters) { results_page_parameters('sort' => sort) }

  before do
    stub_subjects
    stub_courses(query: base_parameters, course_count: 10)

    allow(Settings).to receive(:google).and_return(maps_api_key: 'alohomora')
    allow(Settings).to receive(:google).and_return(maps_api_url: 'https://maps.googleapis.com/maps/api/staticmap')
    visit results_path(params)
  end

  describe 'course count' do
    context 'when API returns courses' do
      it 'displays the correct course count' do
        expect(results_page.text).to have_content('10 courses found')
      end
    end
  end

  context 'provider sorting' do
    let(:ascending_stub) do
      stub_courses(
        query: results_page_parameters('sort' => 'provider.provider_name,name'),
        course_count: 10,
      )
    end

    let(:descending_stub) do
      stub_courses(
        query: results_page_parameters('sort' => '-provider.provider_name,-name'),
        course_count: 10,
      )
    end

    before do
      ascending_stub
      descending_stub
    end

    describe 'hides ordering' do
      let(:base_parameters) { results_page_parameters('sort' => sort, 'filter[provider.provider_name]' => '2AT') }
      let(:sort) { 'provider.provider_name,name' }
      let(:params) { { l: '3', query: '2AT' } }

      it 'does not display the sort form' do
        expect(results_page).not_to have_sort_form
      end
    end

    context 'descending' do
      let(:sort) { '-provider.provider_name,-name' }
      let(:params) { { sortby: '1', l: '2' } }

      it 'requests that the backend sorts the data' do
        expect(descending_stub).to have_been_requested
      end

      it 'is automatically selected' do
        expect(results_page.sort_form.options.descending).to be_selected
      end

      it 'can be changed to ascending' do
        results_page.sort_form.options.ascending.select_option
        results_page.sort_form.submit.click

        expect(Rack::Utils.parse_nested_query(URI(current_url).query)).to eq(
          'sortby' => '0',
          'l' => '2',
        )
      end
    end

    context 'ascending' do
      let(:sort) { 'provider.provider_name,name' }
      let(:params) { { sortby: '0', l: '2' } }

      it 'requests that the backend sorts the data' do
        expect(ascending_stub).to have_been_requested
      end

      it 'is automatically selected' do
        expect(results_page.sort_form.options.ascending).to be_selected
      end

      it 'can be changed to descending' do
        results_page.sort_form.options.descending.select_option
        results_page.sort_form.submit.click

        expect(Rack::Utils.parse_nested_query(URI(current_url).query)).to eq(
          'sortby' => '1',
          'l' => '2',
        )
      end
    end
  end

  describe 'location filter' do
    context 'location with blank provider name' do
      let(:params) do
        {
          l: 2,
          query: '',
          qualifications: %w[QtsOnly PgdePgceWithQts Other],
          fulltime: 'false',
          parttime: 'false',
          hasvacancies: 'true',
          senCourses: 'false',
        }
      end

      it 'falls back to l2 (Across England)' do
        location_filter_uri = URI(current_url)
        expect(location_filter_uri.path).to eq('/results')
        expect(Rack::Utils.parse_nested_query(location_filter_uri.query)).to eq({
          'fulltime' => 'false',
          'hasvacancies' => 'true',
          'l' => '2',
          'parttime' => 'false',
          'qualifications' => %w[QtsOnly PgdePgceWithQts Other],
          'senCourses' => 'false',
          'query' => '',
        })
      end
    end
  end

  context 'with deprecated C# parameters' do
    let(:base_parameters) { results_page_parameters('sort' => sort, 'filter[subjects]' => 'C1,08,F1') }

    let(:params) do
      {
        l: 2,
        query: '',
        qualifications: 'QtsOnly,PgdePgceWithQts,Other',
        subjects: '1,2,3',
        fulltime: 'False',
        parttime: 'False',
        hasvacancies: 'True',
        senCourses: 'False',
        funding: '15',
      }
    end

    it 'sets all parameters correctly' do
      expect(results_page.text).to include('Biology, Business studies and Chemistry courses in England')
      expect(results_page.study_type_filter.parttime_checkbox.checked?).to be(true)
      expect(results_page.study_type_filter.fulltime_checkbox.checked?).to be(true)
      expect(results_page.qualifications_filter.qts_checkbox.checked?).to be(true)
      expect(results_page.qualifications_filter.pgce_checkbox.checked?).to be(true)
      expect(results_page.qualifications_filter.further_education_checkbox.checked?).to be(true)
      expect(results_page.funding_filter.checkbox.checked?).to be(false)
      expect(results_page.vacancies_filter.checkbox.checked?).to be(true)
    end

    it 'transmits translated subject codes to BigQuery' do
      activate_feature(:send_web_requests_to_big_query)
      visit results_path(params)

      bq_event = enqueued_jobs.first['arguments'].first
      subject_codes = bq_event['request_query'].find { |q| q['key'] == 'subject_codes[]' }

      expect(subject_codes).to be_present
      expect(subject_codes['value']).to eq %w[C1 08 F1]
    end
  end
end
