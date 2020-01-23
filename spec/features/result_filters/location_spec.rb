require "rails_helper"

feature "Location filter", type: :feature do
  let(:filter_page) { PageObjects::Page::ResultFilters::Location.new }
  let(:results_page) { PageObjects::Page::Results.new }

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
    before { filter_page.load }

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
