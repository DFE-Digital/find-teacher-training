require "rails_helper"

feature "Study type filter", type: :feature do
  let(:filter_page) { PageObjects::Page::ResultFilters::StudyType.new }
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

    it "Allows the user to select full time" do
      filter_page.full_time.click
      filter_page.find_courses.click

      expect_page_to_be_displayed_with_query(
        page: results_page,
        expected_query_params: {
          "fulltime" => "True",
          "parttime" => "False",
        },
      )
    end

    it "Allows the user to select part time" do
      filter_page.part_time.click
      filter_page.find_courses.click
      expect_page_to_be_displayed_with_query(
        page: results_page,
        expected_query_params: {
          "fulltime" => "False",
          "parttime" => "True",
        },
      )
    end

    it "Allows the user to select both full and part time" do
      filter_page.full_time.click
      filter_page.part_time.click
      filter_page.find_courses.click
      expect_page_to_be_displayed_with_query(
        page: results_page,
        expected_query_params: {
          "fulltime" => "True",
          "parttime" => "True",
        },
      )
    end
  end

  describe "Navigating to the page with currently selected filters" do
    it "Allows the full time param to be pre-selected" do
      filter_page.load(query: { fulltime: "True" })
      expect(filter_page.full_time.checked?).to eq(true)
    end

    it "Allows the part time param to be pre-selected" do
      filter_page.load(query: { parttime: "True" })
      expect(filter_page.part_time.checked?).to eq(true)
    end
  end

  describe "Validation" do
    it "Displays an error if neither option is selected" do
      filter_page.load
      filter_page.find_courses.click

      expect(filter_page).to have_error
    end
  end

  describe "QS parameters" do
    it "passes querystring parameters to results" do
      filter_page.load(query: { test: "value" })
      filter_page.part_time.click
      filter_page.find_courses.click

      expect_page_to_be_displayed_with_query(
        page: results_page,
        expected_query_params: {
          "fulltime" => "False",
          "parttime" => "True",
          "test" => "value",
        },
      )
    end

    it "passes arrays correctly" do
      url_with_array_params = "#{filter_page.url}?test[]=1&test[]=2"
      PageObjects::Page::ResultFilters::StudyType.set_url(url_with_array_params)

      filter_page.load
      filter_page.part_time.click
      filter_page.find_courses.click

      expect(results_page).to be_displayed

      expect_page_to_be_displayed_with_query(
        page: results_page,
        expected_query_params: {
          "fulltime" => "False",
          "parttime" => "True",
          "test" => %w(1 2),
        },
      )
    end
  end
end
