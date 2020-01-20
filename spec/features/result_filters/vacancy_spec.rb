require "rails_helper"

feature "Vacancy filter", type: :feature do
  let(:filter_page) { PageObjects::Page::ResultFilters::Vacancy.new }
  let(:results_page) { PageObjects::Page::Results.new }

  before do
    stub_results_page_request
  end

  describe "Navigating to the page with no selected filters" do
    it "Defaults to with vacancies" do
      filter_page.load
      expect(filter_page.with_vacancies.checked?).to eq(true)
    end
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

    it "Allows the user to select with vacancies" do
      filter_page.with_vacancies.click
      filter_page.find_courses.click

      expect_page_to_be_displayed_with_query(
        page: results_page,
        expected_query_params: {
          "hasvacancies" => "True",
        },
      )
    end

    it "Allows the user to select with and without vacancies" do
      filter_page.with_and_without_vacancies.click
      filter_page.find_courses.click
      expect_page_to_be_displayed_with_query(
        page: results_page,
        expected_query_params: {
          "hasvacancies" => "False",
        },
      )
    end
  end

  describe "Navigating to the page with currently selected filters" do
    it "Preselects with vacancies" do
      filter_page.load(query: { hasvacancies: "True" })
      expect(filter_page.with_vacancies.checked?).to eq(true)
    end

    it "Preselects with and without vacancies" do
      filter_page.load(query: { hasvacancies: "False" })
      expect(filter_page.with_and_without_vacancies.checked?).to eq(true)
    end
  end

  describe "QS parameters" do
    it "passes querystring parameters to results" do
      filter_page.load(query: { test: "value" })
      filter_page.with_vacancies.click
      filter_page.find_courses.click

      expect_page_to_be_displayed_with_query(
        page: results_page,
        expected_query_params: {
          "hasvacancies" => "True",
          "test" => "value",
        },
      )
    end

    it "passes arrays correctly" do
      url_with_array_params = "#{filter_page.url}?test[]=1&test[]=2"
      PageObjects::Page::ResultFilters::Vacancy.set_url(url_with_array_params)

      filter_page.load
      filter_page.with_vacancies.click
      filter_page.find_courses.click

      expect(results_page).to be_displayed

      expect_page_to_be_displayed_with_query(
        page: results_page,
        expected_query_params: {
          "hasvacancies" => "True",
          "test" => %w(1 2),
        },
      )
    end
  end
end
