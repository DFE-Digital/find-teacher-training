require 'rails_helper'

describe 'results', type: :feature do
  let(:results_page) { PageObjects::Page::Results.new }
  let(:sort) { 'provider.provider_name,name' }
  let(:params) {}
  let(:base_parameters) { results_page_parameters('sort' => sort) }

  let(:results_page_request) do
    {
      course_stub: stub_request(:get, courses_url)
        .with(query: base_parameters)
        .to_return(
          body: courses,
          headers: { "Content-Type": 'application/vnd.api+json; charset=utf-8' },
        ),
    }
  end

  let(:courses) do
    File.new('spec/fixtures/api_responses/ten_courses.json')
  end

  before do
    stub_request(
      :get,
      "#{Settings.teacher_training_api.base_url}/api/v3/subjects?fields%5Bsubjects%5D=subject_name,subject_code&sort=subject_name",
    ).to_return(
      body: File.new('spec/fixtures/api_responses/subjects_sorted_name_code.json'),
      headers: { "Content-Type": 'application/vnd.api+json; charset=utf-8' },
    )

    results_page_request

    allow(Settings).to receive(:google).and_return(maps_api_key: 'alohomora')
    allow(Settings).to receive(:google).and_return(maps_api_url: 'https://maps.googleapis.com/maps/api/staticmap')
    visit results_path(params)
  end

  describe 'course count' do
    context 'when API returns courses' do
      it 'displays the correct course count' do
        expect(results_page.course_count).to have_content('10 courses found')
      end
    end
  end

  describe 'filters defaults without query string' do
    it 'has study type filter' do
      expect(results_page.study_type_filter.subheading).to have_content('Study type:')
      expect(results_page.study_type_filter.fulltime).to have_content('Full time (12 months)')
      expect(results_page.study_type_filter.parttime).to have_content('Part time (18 - 24 months)')
      expect(results_page.study_type_filter.link).to have_content('Change study type')
    end

    it 'has vacancies filter' do
      expect(results_page.vacancies_filter.subheading).to have_content('Vacancies:')
      expect(results_page.vacancies_filter.vacancies).to have_content('Courses with and without vacancies')
      expect(results_page.vacancies_filter.link).to have_content('Change vacancies')
    end

    it 'has location filter' do
      expect(results_page.location_filter.name).to have_content('Across England')
      expect(results_page.location_filter).to have_no_distance
      expect(results_page.location_filter.link).to have_content('Change location or choose a provider')
      results_page.location_filter.link.click
      location_filter_uri = URI(current_url)
      expect(location_filter_uri.path).to eq('/results/filter/location')
      expect(Rack::Utils.parse_nested_query(location_filter_uri.query)).to eq({
        'fulltime' => 'false',
        'hasvacancies' => 'false',
        'parttime' => 'false',
        'qualifications' => %w[QtsOnly PgdePgceWithQts Other],
        'senCourses' => 'false',
      })
    end

    it 'has subjects filter' do
      expect(results_page.subjects_filter.subjects.map(&:text))
        .to match_array(
          [
            'Art and design',
            'Biology',
            'Business studies',
            'Chemistry',
          ],
        )
      expect(results_page.subjects_filter.extra_subjects.text).to eq('and 37 more...')
    end

    it 'renders the feedback component' do
      expect(results_page.feedback_link[:href]).to eq('https://www.apply-for-teacher-training.service.gov.uk/candidate/find-feedback?path=/results&find_controller=results')
    end
  end

  describe 'filters defaults with query string' do
    let(:params) { { fulltime: 'false', parttime: 'false', hasvacancies: 'false' } }

    it 'has study type filter' do
      expect(results_page.study_type_filter.subheading).to have_content('Study type:')
      expect(results_page.study_type_filter.fulltime).to have_content('Full time (12 months)')
      expect(results_page.study_type_filter.parttime).to have_content('Part time (18 - 24 months)')
      expect(results_page.study_type_filter.link).to have_content('Change study type')
    end

    it 'has vacancies filter' do
      expect(results_page.vacancies_filter.subheading).to have_content('Vacancies:')
      expect(results_page.vacancies_filter.vacancies).to have_content('Courses with and without vacancies')
      expect(results_page.vacancies_filter.link).to have_content('Change vacancies')
    end

    it 'has location filter' do
      expect(results_page.location_filter.name).to have_content('Across England')
      expect(results_page.location_filter).to have_no_distance
    end
  end

  context 'provider sorting' do
    let(:ascending_stub) do
      stub_request(:get, courses_url)
        .with(query: results_page_parameters('sort' => 'provider.provider_name,name'))
        .to_return(
          body: File.new('spec/fixtures/api_responses/ten_courses.json'),
          headers: { "Content-Type": 'application/vnd.api+json; charset=utf-8' },
        )
    end

    let(:descending_stub) do
      stub_request(:get, courses_url)
        .with(query: results_page_parameters('sort' => '-provider.provider_name,-name'))
        .to_return(
          body: File.new('spec/fixtures/api_responses/ten_courses.json'),
          headers: { "Content-Type": 'application/vnd.api+json; charset=utf-8' },
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

  describe 'study type filter' do
    let(:base_parameters) { results_page_parameters('filter[study_type]' => study_type, 'sort' => sort) }

    context 'for full time only' do
      let(:study_type) { 'full_time' }

      let(:params) { { fulltime: 'true', parttime: 'false' } }

      it 'has study type filter for full time only ' do
        expect(results_page.study_type_filter.subheading).to have_content('Study type:')
        expect(results_page.study_type_filter.fulltime).to have_content('Full time (12 months)')
        expect(results_page.study_type_filter).not_to have_parttime
        expect(results_page.study_type_filter.link).to have_content('Change study type')
      end
    end

    context 'for part time only' do
      let(:study_type) { 'part_time' }
      let(:params) { { fulltime: 'false', parttime: 'true' } }

      it 'has study type filter for part time only' do
        expect(results_page.study_type_filter.subheading).to have_content('Study type:')
        expect(results_page.study_type_filter).not_to have_fulltime
        expect(results_page.study_type_filter.parttime).to have_content('Part time (18 - 24 months)')
        expect(results_page.study_type_filter.link).to have_content('Change study type')
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
          hasvacancies: 'false',
          senCourses: 'false',
        }
      end

      it 'falls back to l2 (Across England)' do
        location_filter_uri = URI(current_url)
        expect(location_filter_uri.path).to eq('/results')
        expect(Rack::Utils.parse_nested_query(location_filter_uri.query)).to eq({
          'fulltime' => 'false',
          'hasvacancies' => 'false',
          'l' => '2',
          'parttime' => 'false',
          'qualifications' => %w[QtsOnly PgdePgceWithQts Other],
          'senCourses' => 'false',
          'query' => '',
        })
      end
    end
  end

  context 'with C# parameters' do
    let(:base_parameters) { results_page_parameters('sort' => sort, 'filter[subjects]' => 'C1,08,F1') }

    let(:params) do
      {
        l: 2,
        query: '',
        qualifications: 'QtsOnly,PgdePgceWithQts,Other',
        subjects: '1,2,3',
        fulltime: 'False',
        parttime: 'False',
        hasvacancies: 'False',
        senCourses: 'False',
        funding: '15',
      }
    end

    it 'sets all parameters correctly' do
      expect(results_page.location_filter.name).to have_content('Across England')
      expect(results_page.subjects_filter.subjects.map(&:text))
        .to match_array(['Biology', 'Business studies', 'Chemistry'])
      expect(results_page.study_type_filter.fulltime).to have_content('Full time (12 months)')
      expect(results_page.study_type_filter.parttime).to have_content('Part time (18 - 24 months)')
      expect(results_page.qualifications_filter).to have_content('All qualifications')
      expect(results_page.funding_filter).to have_with_or_without_salary
      expect(results_page.vacancies_filter).to have_content('Courses with and without vacancies')
    end
  end
end
