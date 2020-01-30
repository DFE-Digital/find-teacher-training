require "rails_helper"

feature "Location filter", type: :feature do
  let(:filter_page) { PageObjects::Page::ResultFilters::Location.new }
  let(:provider_page) { PageObjects::Page::ResultFilters::ProviderPage.new }
  let(:results_page) { PageObjects::Page::Results.new }
  let(:query_params) { {} }

  before do
    stub_results_page_request
  end

  describe "back link" do
    it "navigates back to the results page" do
      filter_page.load(query: { test: "params" })
      filter_page.back_link.click

      expect_page_to_be_displayed_with_query(
        page: results_page,
        expected_query_params: { "test" => "params" },
      )
    end
  end

  describe "Selecting an option" do
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

    context "selecting by provider" do
      it "the user can search by provider" do
        stub_api_v3_resource(
          type: Provider,
          resources: [],
          fields: { providers: %i[provider_code provider_name] },
          params: { recruitment_cycle_year: 2020 },
          search: "ACME",
        )

        filter_page.by_provider.click
        filter_page.provider_search.fill_in(with: "ACME")
        filter_page.find_courses.click

        expect(provider_page.url).to eq(current_path)
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
            resources: [],
            fields: { providers: %i[provider_code provider_name] },
            params: { recruitment_cycle_year: 2020 },
            search: "ACME",
          )

          filter_page.by_provider.click
          filter_page.provider_search.fill_in(with: "ACME")
          filter_page.find_courses.click

          expect(provider_page.url).to eq(current_path)
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

    it "Removes the lat filter" do
      filter_page.load(query: { lat: "yes" })
      filter_page.across_england.click
      filter_page.find_courses.click

      expect_page_to_be_displayed_with_query(
        page: results_page,
        expected_query_params: {
          "l" => "2",
        },
      )
    end

    it "Removes the lng filter" do
      filter_page.load(query: { lng: "yes" })
      filter_page.across_england.click
      filter_page.find_courses.click

      expect_page_to_be_displayed_with_query(
        page: results_page,
        expected_query_params: {
          "l" => "2",
        },
      )
    end

    it "Removes the rad filter" do
      filter_page.load(query: { rad: "yes" })
      filter_page.across_england.click
      filter_page.find_courses.click

      expect_page_to_be_displayed_with_query(
        page: results_page,
        expected_query_params: {
          "l" => "2",
        },
      )
    end

    it "Removes the query filter" do
      filter_page.load(query: { query: "yes" })
      filter_page.across_england.click
      filter_page.find_courses.click

      expect_page_to_be_displayed_with_query(
        page: results_page,
        expected_query_params: {
          "l" => "2",
        },
      )
    end

    it "Removes the loc filter" do
      filter_page.load(query: { loc: "yes" })
      filter_page.across_england.click
      filter_page.find_courses.click

      expect_page_to_be_displayed_with_query(
        page: results_page,
        expected_query_params: {
          "l" => "2",
        },
      )
    end

    it "Removes the lq filter" do
      filter_page.load(query: { lq: "yes" })
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

  describe "Validation" do
    it "Displays an error if no option is selected" do
      filter_page.load
      filter_page.find_courses.click

      expect(filter_page).to have_error
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
      url_with_array_params = "#{filter_page.url}?test[]=1&test[]=2"
      PageObjects::Page::ResultFilters::Location.set_url(url_with_array_params)

      filter_page.load
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
