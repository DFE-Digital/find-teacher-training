require "rails_helper"

feature "Study type filter", type: :feature do
  let(:filter_page) { PageObjects::Page::ResultFilters::StudyType.new }
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
end
