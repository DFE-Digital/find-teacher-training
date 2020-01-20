require "rails_helper"

feature "Vacancy filter", type: :feature do
  let(:filter_page) { PageObjects::Page::ResultFilters::Vacancy.new }
  let(:results_page) { PageObjects::Page::Results.new }
  let(:courses_request) do
    fields = {
      courses: %i[provider_code course_code name description funding_type provider accrediting_provider subjects],
      providers: %i[provider_name address1 address2 address3 address4 postcode],
    }

    params = {
      recruitment_cycle_year: Settings.current_cycle,
      provider_code: nil,
    }

    pagination = { page: 1, per_page: 10 }

    include = %i[provider accrediting_provider financial_incentive subjects]

    stub_api_v3_resource(
      type: Course,
      resources: [],
      params: params,
      fields: fields,
      include: include,
      pagination: pagination,
      links: {
        last: api_v3_url(
          type: Course,
          params: params,
          fields: fields,
          include: include,
          pagination: pagination,
        ),
      },
    )
  end

  before { courses_request }

  describe "Navigating to the page with no selected filters" do
    it "Defaults to with vacancies" do
      filter_page.load
      expect(filter_page.with_vacancies.checked?).to eq(true)
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
