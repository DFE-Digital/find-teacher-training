require "rails_helper"

feature "Location filter", type: :feature do
  let(:filter_page) { PageObjects::Page::ResultFilters::Location.new }
  let(:provider_page) { PageObjects::Page::ResultFilters::ProviderPage.new }
  let(:results_page) { PageObjects::Page::Results.new }
  let(:query_params) { {} }
  let(:courses_url) do
    "http://localhost:3001/api/v3/recruitment_cycles/2020/courses"
  end
  let(:subjects_url) do
    "http://localhost:3001/api/v3/subject_areas?include=subjects"
  end

  let(:base_parameters) { results_page_parameters }

  before do
    stub_geocoder

    stub_request(:get, subjects_url)

    stub_request(:get, courses_url)
        .with(query: base_parameters)
        .to_return(
          body: File.new("spec/fixtures/api_responses/empty_courses.json"),
          headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
            )
  end

  describe "filtering by provider" do
    before do
      stub_request(
        :get,
        "http://localhost:3001/api/v3/recruitment_cycles/2020/providers",
      ).with(
        query: {
          "fields[providers]" => "provider_code,provider_name",
          "search" => "ACME",
        },
      ).to_return(
        body: File.new("spec/fixtures/api_responses/providers.json"),
        headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
      )

      stub_request(:get, courses_url)
        .with(
          query: base_parameters.merge("filter[provider.provider_name]" => "ACME SCITT 0"),
        )
        .to_return(
          body: File.new("spec/fixtures/api_responses/two_courses_with_sites.json"),
          headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
      )
    end

    it "displays the courses" do
      results_page.load
      results_page.location_filter.link.click
      filter_page.by_provider.click
      filter_page.provider_search.fill_in(with: "ACME")
      filter_page.find_courses.click

      expect(provider_page.heading.text).to eq("Pick a provider")
      provider_page.provider_suggestions[0].hyperlink.click

      expect(results_page.courses.first).to have_main_address
      expect(results_page.courses.first).not_to have_site_distance_to_location_query
      expect(results_page.courses.first).not_to have_nearest_address

      expect(results_page.heading.text).to eq("Teacher training courses ACME SCITT 0")
      expect(results_page.provider_filter.name.text).to eq("ACME SCITT 0")
      expect(results_page.provider_filter.link.text).to eq("Change provider or choose a location")
      expect(results_page.courses.count).to eq(2)
    end
  end

  describe "filtering by location" do
    before do
      stub_request(:get, courses_url)
        .with(
          query: base_parameters.merge("filter[longitude]" => "-0.1300436",
                                       "filter[latitude]" => "51.4980188",
                                       "filter[radius]" => "20"),
        )
        .to_return(
          body: File.new("spec/fixtures/api_responses/two_courses_with_sites.json"),
          headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
      )
    end

    it "displays the courses" do
      results_page.load
      results_page.location_filter.link.click
      filter_page.by_postcode_town_or_city.click
      filter_page.location_query.fill_in(with: "SW1P 3BT")
      filter_page.find_courses.click

      expect(results_page.heading.text).to eq("Teacher training courses")

      expect(results_page.courses.first).to have_site_distance_to_location_query
      expect(results_page.courses.first).to have_nearest_address
      expect(results_page.courses.first).not_to have_main_address

      expect(results_page.location_filter.name.text).to eq("Westminster, London SW1P 3BT, UK Within 20 miles of the pin")
      expect(results_page.location_filter.map).to be_present
      expect(results_page.courses.count).to eq(2)
    end
  end

  describe "default text" do
    it "displays the query text specified in the params if it exists" do
      filter_page.load(query: { query: "marble" })
      expect(filter_page.provider_search.value).to eq("marble")
    end
  end

  describe "back link" do
    it "navigates back to the results page" do
      filter_page.load(query: { test: "params" })
      filter_page.back_link.click

      expect_page_to_be_displayed_with_query(
        page: results_page,
        expected_query_params: {
          "fulltime" => "False",
          "hasvacancies" => "True",
          "parttime" => "False",
          "qualifications" => "QtsOnly,PgdePgceWithQts,Other",
          "senCourses" => "False",
          "test" => "params",
        },
      )
    end

    context "on the start page" do
      it "has no back link" do
        visit root_path
        expect(filter_page).not_to have_back_link
      end

      it "the submit button displays 'Continue'" do
        visit root_path
        expect(filter_page.find_courses.value).to eq("Continue")
      end

      it "Allows the user to select across england" do
        visit root_path

        filter_page.across_england.click
        filter_page.find_courses.click

        URI(current_url).then do |uri|
          expect(uri.path).to eq("/start/subject")
          expect(uri.query).to eq("l=2")
        end
      end

      it "stays on start page after validations" do
        visit root_path
        filter_page.find_courses.click

        expect(filter_page).to have_error
        expect(page).to have_current_path(root_path, ignore_query: true)
      end
    end
  end

  describe "filtering to Across England" do
    before { filter_page.load(query: query_params) }

    it "Allows the user to select across england" do
      filter_page.across_england.click
      filter_page.find_courses.click

      expect_page_to_be_displayed_with_query(
        page: results_page,
        expected_query_params: {
          "l" => "2",
        },
      )
    end
  end

  context "filtering by provider" do
    before { filter_page.load(query: query_params) }

    let(:providers) { [build(:provider), build(:provider)] }

    it "can search by provider" do
      stub_api_v3_resource(
        type: Provider,
        resources: providers,
        fields: { providers: %i[provider_code provider_name] },
        params: { recruitment_cycle_year: 2020 },
        search: "ACME",
      )

      filter_page.by_provider.click
      filter_page.provider_search.fill_in(with: "ACME")
      filter_page.find_courses.click

      expect(current_path).to eq(provider_page.url)
      expect(Rack::Utils.parse_nested_query(URI(current_url).query)).to eq(
        "l" => "3",
        "query" => "ACME",
      )
    end

    context "with selected options" do
      let(:query_params) { { another_option: "option" } }

      it "preserves other selected options" do
        stub_api_v3_resource(
          type: Provider,
          resources: providers,
          fields: { providers: %i[provider_code provider_name] },
          params: { recruitment_cycle_year: 2020 },
          search: "ACME",
        )

        filter_page.by_provider.click
        filter_page.provider_search.fill_in(with: "ACME")
        filter_page.find_courses.click

        expect(current_path).to eq(provider_page.url)
        expect(Rack::Utils.parse_nested_query(URI(current_url).query)).to eq(
          "l" => "3",
          "query" => "ACME",
          "another_option" => "option",
        )
      end
    end
  end

  describe "Navigating to the page with currently selected filters" do
    it "Preselects by postcode, town or city and reveals the content" do
      filter_page.load(query: { l: 1 })
      expect(filter_page.by_postcode_town_or_city.checked?).to eq(true)
      expect(filter_page.location_conditional).not_to match_selector(".govuk-radios__conditional--hidden")
    end

    it "Preselects across england" do
      filter_page.load(query: { l: 2 })
      expect(filter_page.across_england.checked?).to eq(true)
    end

    it "Preselects by school, university or other training provider and reveals the content" do
      filter_page.load(query: { l: 3 })
      expect(filter_page.by_provider.checked?).to eq(true)
      expect(filter_page.by_provider_conditional).not_to match_selector(".govuk-radios__conditional--hidden")
    end
  end

  describe "Validation" do
    it "Displays an error if no option is selected" do
      filter_page.load
      filter_page.find_courses.click

      expect(filter_page.error.text).to eq("You’ll need to correct some information.\nPlease choose an option")

      expect(page).to have_current_path(location_path, ignore_query: true)
    end

    it "Displays an error if location is selected but none is entered" do
      filter_page.load
      filter_page.by_postcode_town_or_city.click
      filter_page.search_radius.select "5 miles"

      filter_page.find_courses.click

      expect(filter_page.error.text).to eq("You’ll need to correct some information.\nPostcode, town or city")
      expect(filter_page.location_error.text).to eq("Error: Please enter a postcode, city or town in England")
      expect(filter_page).to have_location_query
      expect(filter_page).to have_select("rad", selected: "5 miles")
    end

    it "Displays an error if the the location is unknown" do
      filter_page.load
      filter_page.by_postcode_town_or_city.click
      filter_page.location_query.set "Unknown location"

      filter_page.find_courses.click

      expect(filter_page.error.text).to eq("You’ll need to correct some information.\nPostcode, town or city")
      expect(filter_page.location_error.text).to eq("Error: We couldn't find this location, please check your input and try again")
      expect(filter_page).to have_location_query
      expect(filter_page).to have_unknown_location
    end
  end

  describe "QS parameters" do
    it "passes querystring parameters to results" do
      filter_page.load(query: { test: "value" })
      filter_page.across_england.click
      filter_page.find_courses.click

      expect_page_to_be_displayed_with_query(
        page: results_page,
        expected_query_params: {
          "l" => "2",
          "test" => "value",
        },
      )
    end

    it "passes arrays correctly" do
      #Site prism does not correctly handle array arguments
      visit location_path(test: [1, 2])
      filter_page.across_england.click
      filter_page.find_courses.click

      expect(results_page).to be_displayed

      expect_page_to_be_displayed_with_query(
        page: results_page,
        expected_query_params: {
          "l" => "2",
          "test" => "1,2",
        },
      )
    end
  end
end
