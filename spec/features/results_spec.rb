require 'rails_helper'

describe 'results' do
  include StubbedRequests::Courses
  include StubbedRequests::Subjects
  include ActiveJob::TestHelper

  let(:results_page) { PageObjects::Page::Results.new }
  let(:sort) { 'name,provider.provider_name' }
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

  it 'displays a feedback link' do
    expect(results_page.text).to have_content('How can we improve this page?')
  end

  context 'provider sorting' do
    let(:provider_ascending_stub) do
      stub_courses(
        query: results_page_parameters('sort' => 'provider.provider_name,order'),
        course_count: 10,
      )
    end

    let(:provider_descending_stub) do
      stub_courses(
        query: results_page_parameters('sort' => '-provider.provider_name,order'),
        course_count: 10,
      )
    end

    before do
      provider_ascending_stub
      provider_descending_stub
    end

    describe 'hides ordering' do
      let(:base_parameters) { results_page_parameters('sort' => sort, 'filter[provider.provider_name]' => '2AT') }
      let(:sort) { 'name,provider.provider_name' }
      let(:params) { { l: '3', query: '2AT' } }

      it 'does not display the sort form' do
        expect(results_page).not_to have_sort_form
      end
    end

    context 'descending' do
      let(:sort) { '-provider.provider_name,order' }
      let(:params) { { sortby: 'provider_desc', l: '2' } }

      it 'requests that the backend sorts the data' do
        expect(provider_descending_stub).to have_been_requested
      end

      it 'is automatically selected' do
        expect(results_page.sort_form.options.provider_descending).to be_selected
      end

      it 'can be changed to ascending' do
        results_page.sort_form.options.provider_ascending.select_option
        results_page.sort_form.submit.click

        expect(Rack::Utils.parse_nested_query(URI(current_url).query)).to eq(
          'sortby' => 'provider_asc',
          'l' => '2',
        )
      end
    end

    context 'ascending' do
      let(:sort) { 'provider.provider_name,order' }
      let(:params) { { sortby: 'provider_asc', l: '2' } }

      it 'requests that the backend sorts the data' do
        expect(provider_ascending_stub).to have_been_requested
      end

      it 'is automatically selected' do
        expect(results_page.sort_form.options.provider_ascending).to be_selected
      end

      it 'can be changed to descending' do
        results_page.sort_form.options.provider_descending.select_option
        results_page.sort_form.submit.click

        expect(Rack::Utils.parse_nested_query(URI(current_url).query)).to eq(
          'sortby' => 'provider_desc',
          'l' => '2',
        )
      end
    end
  end

  context 'course sorting' do
    let(:course_ascending_stub) do
      stub_courses(
        query: results_page_parameters('sort' => 'name,provider.provider_name'),
        course_count: 10,
      )
    end

    let(:course_descending_stub) do
      stub_courses(
        query: results_page_parameters('sort' => '-name,provider.provider_name'),
        course_count: 10,
      )
    end

    before do
      course_ascending_stub
      course_descending_stub
    end

    context 'descending' do
      let(:sort) { '-name,provider.provider_name' }
      let(:params) { { sortby: 'course_desc', l: '2' } }

      it 'requests that the backend sorts the data' do
        expect(course_descending_stub).to have_been_requested
      end

      it 'is automatically selected' do
        expect(results_page.sort_form.options.course_descending).to be_selected
      end

      it 'can be changed to ascending' do
        results_page.sort_form.options.course_ascending.select_option
        results_page.sort_form.submit.click

        expect(Rack::Utils.parse_nested_query(URI(current_url).query)).to eq(
          'sortby' => 'course_asc',
          'l' => '2',
        )
      end
    end

    context 'ascending' do
      let(:sort) { 'name,provider.provider_name' }
      let(:params) { { sortby: 'course_asc', l: '2' } }

      it 'requests that the backend sorts the data' do
        expect(course_ascending_stub).to have_been_requested
      end

      it 'is automatically selected' do
        expect(results_page.sort_form.options.course_ascending).to be_selected
      end

      it 'can be changed to descending' do
        results_page.sort_form.options.course_descending.select_option
        results_page.sort_form.submit.click

        expect(Rack::Utils.parse_nested_query(URI(current_url).query)).to eq(
          'sortby' => 'course_desc',
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
  end
end
