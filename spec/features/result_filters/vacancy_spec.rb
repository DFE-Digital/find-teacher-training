require "rails_helper"

feature "Vacancy filter", type: :feature do
  let(:filter_page) { PageObjects::Page::ResultFilters::Vacancy.new }
  let(:results_page) { PageObjects::Page::Results.new }
  let(:default_url) do
    "http://localhost:3001/api/v3/recruitment_cycles/2020/courses?include=provider&filter[vacancies]=true&page%5Bpage%5D=1&page%5Bper_page%5D=10"
  end

  describe "viewing results without explicitly selecting a filter" do
    before do
      stub_request(
        :get,
        default_url,
      ).to_return(
        body: File.new("spec/fixtures/api_responses/courses.json"),
        headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
      )
    end

    it "lists only courses with vacancies" do
      results_page.load

      expect(results_page.vacancies_filter.vacancies.text).to eq("Only courses with vacancies")
      expect(results_page.courses.count).to eq(2)
    end
  end

  describe "selecting a filter" do
    context "selecting with or without vacancies" do
      before do
        stub_request(
          :get,
          default_url,
        ).to_return(
          body: File.new("spec/fixtures/api_responses/empty_courses.json"),
          headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
        )

        stub_request(
          :get,
          "http://localhost:3001/api/v3/recruitment_cycles/2020/courses?include=provider&filter[vacancies]=false&page%5Bpage%5D=1&page%5Bper_page%5D=10",
        ).to_return(
          body: File.new("spec/fixtures/api_responses/courses.json"),
          headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
        )
      end

      it "list the courses" do
        results_page.load
        results_page.vacancies_filter.link.click

        expect(filter_page.heading.text).to eq("Find courses by vacancies")
        filter_page.with_and_without_vacancies.click
        filter_page.find_courses.click

        expect(results_page.heading.text).to eq("Teacher training courses")
        expect(results_page.vacancies_filter.vacancies.text).to eq("Courses with and without vacancies")

        expect(results_page.courses.count).to eq(2)
      end
    end

    context "selecting only courses with vacancies" do
      before do
        stub_request(
          :get,
          "http://localhost:3001/api/v3/recruitment_cycles/2020/courses?include=provider&page%5Bpage%5D=1&page%5Bper_page%5D=10",
        ).to_return(
          body: File.new("spec/fixtures/api_responses/empty_courses.json"),
          headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
        )

        stub_request(
          :get,
          "http://localhost:3001/api/v3/recruitment_cycles/2020/courses?include=provider&filter[vacancies]=true&page%5Bpage%5D=1&page%5Bper_page%5D=10",
        ).to_return(
          body: File.new("spec/fixtures/api_responses/courses.json"),
          headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
        )
      end

      it "lists the courses" do
        results_page.load
        results_page.vacancies_filter.link.click

        expect(filter_page.heading.text).to eq("Find courses by vacancies")

        filter_page.with_vacancies.click
        filter_page.find_courses.click

        expect(results_page.heading.text).to eq("Teacher training courses")
        expect(results_page.vacancies_filter.vacancies.text).to eq("Only courses with vacancies")

        expect(results_page.courses.count).to eq(2)
      end
    end
  end
end

  # before do
  #   stub_results_page_request
  # end

  # describe "Navigating to the page with no selected filters" do
  #   it "Defaults to with vacancies" do
  #     filter_page.load
  #     expect(filter_page.with_vacancies.checked?).to eq(true)
  #   end
  # end

  # describe "back link" do
  #   it "navigates back to the results page" do
  #     filter_page.load(query: { test: "params" })
  #     filter_page.back_link.click

  #     expect_page_to_be_displayed_with_query(
  #       page: results_page,
  #       expected_query_params:  {
  #         "fulltime" => "False",
  #         "hasvacancies" => "True",
  #         "parttime" => "False",
  #         "qualifications" => "QtsOnly,PgdePgceWithQts,Other",
  #         "senCourses" => "False",
  #         "test" => "params",
  #       },
  #     )
  #   end
  # end

  # describe "Selecting an option" do
  #   before { filter_page.load }

  #   it "Allows the user to select with vacancies" do
  #     filter_page.with_vacancies.click
  #     filter_page.find_courses.click

  #     expect_page_to_be_displayed_with_query(
  #       page: results_page,
  #       expected_query_params: {
  #         "hasvacancies" => "True",
  #       },
  #     )
  #   end

  #   it "Allows the user to select with and without vacancies" do
  #     filter_page.with_and_without_vacancies.click
  #     filter_page.find_courses.click
  #     expect_page_to_be_displayed_with_query(
  #       page: results_page,
  #       expected_query_params: {
  #         "hasvacancies" => "False",
  #       },
  #     )
  #   end
  # end

  # describe "Navigating to the page with currently selected filters" do
  #   it "Preselects with vacancies" do
  #     filter_page.load(query: { hasvacancies: "True" })
  #     expect(filter_page.with_vacancies.checked?).to eq(true)
  #   end

  #   it "Preselects with and without vacancies" do
  #     filter_page.load(query: { hasvacancies: "False" })
  #     expect(filter_page.with_and_without_vacancies.checked?).to eq(true)
  #   end
  # end

  # describe "QS parameters" do
  #   it "passes querystring parameters to results" do
  #     filter_page.load(query: { test: "value" })
  #     filter_page.with_vacancies.click
  #     filter_page.find_courses.click

  #     expect_page_to_be_displayed_with_query(
  #       page: results_page,
  #       expected_query_params: {
  #         "hasvacancies" => "True",
  #         "test" => "value",
  #       },
  #     )
  #   end

  #   it "passes arrays correctly" do
  #     url_with_array_params = "#{filter_page.url}?test[]=1&test[]=2"
  #     PageObjects::Page::ResultFilters::Vacancy.set_url(url_with_array_params)

  #     filter_page.load
  #     filter_page.with_vacancies.click
  #     filter_page.find_courses.click

  #     expect(results_page).to be_displayed

  #     expect_page_to_be_displayed_with_query(
  #       page: results_page,
  #       expected_query_params: {
  #         "hasvacancies" => "True",
  #         "test" => "1,2",
  #       },
  #     )
  #   end
  # end
# end
