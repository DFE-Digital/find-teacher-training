require "rails_helper"

feature "results", type: :feature do
  let(:results_page) { PageObjects::Page::Results.new }
  let(:sort) { "provider.provider_name,name" }
  let(:params) {}
  let(:default_url) do
    "http://localhost:3001/api/v3/recruitment_cycles/2020/courses"
  end

  let(:base_parameters) { results_page_parameters("sort" => sort) }

  let(:results_page_request) do
    {
      course_stub: stub_request(:get, default_url)
        .with(query: base_parameters)
        .to_return(
          body: courses,
          headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
      ),
    }
  end

  let(:courses) do
    File.new("spec/fixtures/api_responses/courses.json")
  end

  before do
    stub_request(
      :get,
      "http://localhost:3001/api/v3/subject_areas?include=subjects",
    ).to_return(
      body: File.new("spec/fixtures/api_responses/subject_areas.json"),
      headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
    )

    results_page_request

    allow(Settings).to receive_message_chain(:google, :maps_api_key).and_return("alohomora")
    allow(Settings).to receive_message_chain(:google, :maps_api_url).and_return("https://maps.googleapis.com/maps/api/staticmap")
    visit results_path(params)
  end

  describe "course count" do
    context "when API returns courses" do
      it "displays the correct course count" do
        expect(results_page.course_count).to have_content("8,900 courses found")
      end
    end
  end

  fdescribe "search suggestions" do
    context "when the API returns 3 or more courses" do
      it "does not show any search suggestions" do
        expect(results_page).not_to have_suggestions_section
      end
    end

    context "when the API returns less than 3 courses" do
      let(:courses) do
        File.new("spec/fixtures/api_responses/empty_courses.json")
      end

      let(:base_parameters) { results_page_parameters("rad" => "5", "sort" => sort) }
      let(:results_page_request) do
        {
          less_specific_course_stub: stub_request(:get, default_url)
            .with(query: base_parameters)
            .to_return(
              body: File.new("spec/fixtures/api_responses/courses.json"),
              headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
          ),
          course_stub: stub_request(:get, default_url)
            .with(query: base_parameters)
            .to_return(
              body: courses,
              headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
          ),
        }
      end

      it "requests data for a less specific search" do
        expect(results_page_request[:less_specific_course_stub]).to have_been_requested
      end

      xit "shows search suggestions" do
        expect(results_page).not_to have_suggestions_section
      end
    end
  end

  describe "filters defaults without query string" do
    it "has study type filter" do
      expect(results_page.study_type_filter.subheading).to have_content("Study type:")
      expect(results_page.study_type_filter.fulltime).to have_content("Full time (12 months)")
      expect(results_page.study_type_filter.parttime).to have_content("Part time (18 - 24 months)")
      expect(results_page.study_type_filter.link).to have_content("Change study type")
    end

    it "has vacancies filter" do
      expect(results_page.vacancies_filter.subheading).to have_content("Vacancies:")
      expect(results_page.vacancies_filter.vacancies).to have_content("Only courses with vacancies")
      expect(results_page.vacancies_filter.link).to have_content("Change vacancies")
    end

    it "has location filter" do
      expect(results_page.location_filter.name).to have_content("Across England")
      expect(results_page.location_filter).to have_no_distance
      expect(results_page.location_filter.link).to have_content("Change location or choose a provider")
      results_page.location_filter.link.click
      location_filter_uri = URI(current_url)
      expect(location_filter_uri.path).to eq("/results/filter/location")
      expect(location_filter_uri.query).to eq("qualifications=QtsOnly,PgdePgceWithQts,Other&fulltime=False&parttime=False&hasvacancies=True&senCourses=False")
    end

    it "has subjects filter" do
      expect(results_page.subjects_filter.subjects.map(&:text))
        .to match_array(
          [
            "Art and design",
            "Biology",
            "Business studies",
            "Chemistry",
          ],
      )
      expect(results_page.subjects_filter.extra_subjects.text).to eq("and 37 more...")
    end
  end

  describe "filters defaults with query string" do
    let(:params) { { fulltime: "False", parttime: "False", hasvacancies: "True" } }

    it "has study type filter" do
      expect(results_page.study_type_filter.subheading).to have_content("Study type:")
      expect(results_page.study_type_filter.fulltime).to have_content("Full time (12 months)")
      expect(results_page.study_type_filter.parttime).to have_content("Part time (18 - 24 months)")
      expect(results_page.study_type_filter.link).to have_content("Change study type")
    end

    it "has vacancies filter" do
      expect(results_page.vacancies_filter.subheading).to have_content("Vacancies:")
      expect(results_page.vacancies_filter.vacancies).to have_content("Only courses with vacancies")
      expect(results_page.vacancies_filter.link).to have_content("Change vacancies")
    end

    it "has location filter" do
      expect(results_page.location_filter.name).to have_content("Across England")
      expect(results_page.location_filter).to have_no_distance
    end
  end

  context "provider sorting" do
    let(:ascending_stub) do
      stub_request(:get, default_url)
        .with(query: results_page_parameters("sort" => "provider.provider_name,name"))
        .to_return(
          body: File.new("spec/fixtures/api_responses/courses.json"),
          headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
        )
    end

    let(:descending_stub) do
      stub_request(:get, default_url)
        .with(query: results_page_parameters("sort" => "-provider.provider_name,-name"))
        .to_return(
          body: File.new("spec/fixtures/api_responses/courses.json"),
          headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
        )
    end

    before do
      ascending_stub
      descending_stub
    end

    describe "hides ordering" do
      let(:sort) { "provider.provider_name,name" }
      let(:params) { { l: "3" } }

      it "does not display the sort form" do
        expect(results_page).not_to have_sort_form
      end
    end

    context "descending" do
      let(:sort) { "-provider.provider_name,-name" }
      let(:params) { { sortby: "1", l: "2" } }

      it "requests that the backend sorts the data" do
        expect(descending_stub).to have_been_requested
      end

      it "is automatically selected" do
        expect(results_page.sort_form.options.descending).to be_selected
      end

      it "can be changed to ascending" do
        results_page.sort_form.options.ascending.select_option
        results_page.sort_form.submit.click

        expect(Rack::Utils.parse_nested_query(URI(current_url).query)).to eq(
          "sortby" => "0",
          "l" => "2",
        )
      end
    end

    context "ascending" do
      let(:sort) { "provider.provider_name,name" }
      let(:params) { { sortby: "0", l: "2" } }

      it "requests that the backend sorts the data" do
        expect(ascending_stub).to have_been_requested
      end

      it "is automatically selected" do
        expect(results_page.sort_form.options.ascending).to be_selected
      end

      it "can be changed to descending" do
        results_page.sort_form.options.descending.select_option
        results_page.sort_form.submit.click

        expect(Rack::Utils.parse_nested_query(URI(current_url).query)).to eq(
          "sortby" => "1",
          "l" => "2",
        )
      end
    end
  end

  describe "study type filter" do
    let(:base_parameters) { results_page_parameters("filter[study_type]" => study_type, "sort" => sort) }

    context "for full time only" do
      let(:study_type) { "full_time" }

      let(:params) { { fulltime: "True", parttime: "False" } }

      it "has study type filter for full time only " do
        expect(results_page.study_type_filter.subheading).to have_content("Study type:")
        expect(results_page.study_type_filter.fulltime).to have_content("Full time (12 months)")
        expect(results_page.study_type_filter).not_to have_parttime
        expect(results_page.study_type_filter.link).to have_content("Change study type")
      end
    end

    context "for part time only" do
      let(:study_type) { "part_time" }
      let(:params) { { fulltime: "False", parttime: "True" } }

      it "has study type filter for part time only" do
        expect(results_page.study_type_filter.subheading).to have_content("Study type:")
        expect(results_page.study_type_filter).not_to have_fulltime
        expect(results_page.study_type_filter.parttime).to have_content("Part time (18 - 24 months)")
        expect(results_page.study_type_filter.link).to have_content("Change study type")
      end
    end
  end

  describe "location filter" do
    context "location selected within 10 miles" do
      let(:params) do
        {
          loc: "Hogwarts, Reading, UK",
          rad: "10",
          lng: "-27.1504002",
          lat: "-109.3042697",
        }
      end

      it "displays the location filter" do
        expected_url = "https://maps.googleapis.com/maps/api/staticmap?key=alohomora&center=-109.3042697,-27.1504002&zoom=11&size=300x200&scale=2&markers=-109.3042697,-27.1504002"
        expect(results_page.location_filter.name).to have_content("Hogwarts, Reading, UK")
        expect(results_page.location_filter.distance).to have_content("Within 10 miles of the pin")
        expect(results_page.location_filter.map["src"]).to have_content(expected_url)
        results_page.location_filter.link.click
        location_filter_uri = URI(current_url)
        expect(location_filter_uri.path).to eq("/results/filter/location")
        expect(location_filter_uri.query).to eq("lat=-109.3042697&lng=-27.1504002&loc=Hogwarts,+Reading,+UK&rad=10&qualifications=QtsOnly,PgdePgceWithQts,Other&fulltime=False&parttime=False&hasvacancies=True&senCourses=False")
      end
    end
  end
end
