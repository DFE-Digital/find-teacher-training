require "rails_helper"

feature "Vacancy filter", type: :feature do
  let(:filter_page) { PageObjects::Page::ResultFilters::Vacancy.new }
  let(:results_page) { PageObjects::Page::Results.new }
  let(:courses_url) do
    "http://localhost:3001/api/v3/recruitment_cycles/2020/courses"
  end
  let(:subjects_url) do
    "http://localhost:3001/api/v3/subject_areas?include=subjects"
  end

  let(:base_parameters) { results_page_parameters }

  before do
    stub_request(:get, subjects_url)
  end

  describe "Vacancy filter page" do
    before { filter_page.load }

    it "has the correct title and heading" do
      expect(page.title).to have_content("Find courses by vacancies")
      expect(page).to have_content("Find courses by vacancies")
    end

    describe "back link" do
      before do
        stub_request(:get, courses_url)
          .with(query: base_parameters)
          .to_return(
            body: File.new("spec/fixtures/api_responses/ten_courses.json"),
            headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
        )
      end

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
  end

  describe "viewing results without explicitly selecting a filter" do
    before do
      stub_request(:get, courses_url)
        .with(query: base_parameters)
        .to_return(
          body: File.new("spec/fixtures/api_responses/ten_courses.json"),
          headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
      )
    end

    it "lists only courses with vacancies" do
      results_page.load

      expect(results_page.vacancies_filter.vacancies.text).to eq("Only courses with vacancies")
      expect(results_page.courses.count).to eq(10)
    end
  end

  describe "applying a filter" do
    before do
      stub_request(:get, courses_url)
        .with(query: base_parameters)
        .to_return(
          body: File.new("spec/fixtures/api_responses/ten_courses.json"),
          headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
      )
    end

    context "selecting courses with or without vacancies" do
      before do
        stub_request(:get, courses_url)
          .with(query: base_parameters.merge("filter[has_vacancies]" => "false"))
          .to_return(
            body: File.new("spec/fixtures/api_responses/ten_courses.json"),
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
        expect(results_page.courses.count).to eq(10)
      end
    end

    context "selecting courses with vacancies" do
      before do
        stub_request(:get, courses_url)
          .with(query: base_parameters.merge("filter[has_vacancies]" => "true"))
          .to_return(
            body: File.new("spec/fixtures/api_responses/ten_courses.json"),
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

        expect(results_page.courses.count).to eq(10)
      end
    end
  end
end
