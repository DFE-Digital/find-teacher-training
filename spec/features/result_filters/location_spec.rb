require "rails_helper"

feature "Location filter", type: :feature do
  let(:filter_page) { PageObjects::Page::ResultFilters::Location.new }
  let(:provider_page) { PageObjects::Page::ResultFilters::ProviderPage.new }
  let(:results_page) { PageObjects::Page::Results.new }
  let(:query_params) { {} }

  before do
    stub_geocoder
    stub_results_page_request
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
  end

  describe "Selecting an option" do
    before { filter_page.load(query: query_params) }

    it "Allows the user to select 'by postcode, town or city'" do
      location_filter_results_page = PageObjects::Page::ResultFilters::LocationFilterResults.new

      filter_page.by_postcode_town_or_city.click
      filter_page.location_query.set "SW1P 3BT"
      filter_page.search_radius.select "5 miles"

      filter_page.find_courses.click

      expect_page_to_be_displayed_with_query(
        page: location_filter_results_page,
        expected_query_params: {
          "l" => "1",
          "lat" => "51.4980188",
          "lng" => "-0.1300436",
          "loc" => "Westminster, London SW1P 3BT, UK",
          "lq" => "SW1P 3BT",
          "rad" => "5",
        },
      )
    end

    it "Allows the user to select across england" do
      filter_page.across_england.click
      filter_page.find_courses.click

      expect_page_to_be_displayed_with_query(
        page: results_page,
        expected_query_params: {
          "l" => "2",
          "rad" => "20",
        },
      )
    end

    context "selecting by provider" do
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
  end

  describe "Navigating to the page with currently selected filters" do
    it "Preselects across england" do
      filter_page.load(query: { l: 2 })
      expect(filter_page.across_england.checked?).to eq(true)
    end
  end

  describe "Validation" do
    it "Displays an error if no option is selected" do
      filter_page.load
      filter_page.find_courses.click

      expect(filter_page.error.text).to eq("You’ll need to correct some information.\nPlease choose an option")
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
          "rad" => "20",
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
          "rad" => "20",
        },
      )
    end
  end
end
