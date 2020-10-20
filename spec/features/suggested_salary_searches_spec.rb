require "rails_helper"

describe "Suggested salary searches" do
  let(:filter_page) { PageObjects::Page::ResultFilters::Funding.new }
  let(:results_page) { PageObjects::Page::Results.new }

  def default_query_for_location_search(radius:)
    { l: 1, loc: "Cat Town", lq: "Cat Town", lat: 51.4980188, lng: -0.1300436, rad: radius }
  end

  def stub_subjects
    stub_request(
      :get,
      "#{Settings.teacher_training_api.base_url}/api/v3/subjects?fields%5Bsubjects%5D=subject_name,subject_code&sort=subject_name",
    ).to_return(
      body: File.new("spec/fixtures/api_responses/subjects_sorted_name_code.json"),
      headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
    )
  end

  def course_fixture_for(results:)
    file_name = case results
                when 0
                  "empty_courses.json"
                when 2
                  "two_courses.json"
                when 4
                  "four_courses.json"
                when 10
                  "ten_courses.json"
                end

    File.new("spec/fixtures/api_responses/#{file_name}")
  end

  def suggested_search_count_parameters
    results_page_parameters.reject do |k, _v|
      ["page[page]", "page[per_page]", "sort"].include?(k)
    end
  end

  def stub_courses(number_of_results:, query:)
    stub_request(:get, courses_url)
      .with(query: query)
      .to_return(
        body: course_fixture_for(results: number_of_results),
        headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
      )
  end

  def stub_suggested_across_england_with_salary_filter(number_of_results:)
    stub_courses(
      number_of_results: number_of_results,
      query: suggested_search_count_parameters.merge("filter[funding]" => "salary"),
    )
  end

  def stub_suggested_across_england_without_salary_filter(number_of_results:)
    stub_courses(
      number_of_results: number_of_results,
      query: suggested_search_count_parameters,
    )
  end

  def stub_results_with_salary_filter(radius:, number_of_results:)
    stub_courses(
      number_of_results: number_of_results,
      query: results_page_parameters.merge(
        "filter[funding]" => "salary",
        "filter[latitude]" => 51.4980188,
        "filter[longitude]" => -0.1300436,
        "filter[radius]" => radius,
        "filter[expand_university]" => false,
      ),
    )
  end

  def stub_suggested_with_salary_filter(radius:, number_of_results:)
    stub_courses(
      number_of_results: number_of_results,
      query: suggested_search_count_parameters.merge(
        "filter[funding]" => "salary",
        "filter[latitude]" => 51.4980188,
        "filter[longitude]" => -0.1300436,
        "filter[radius]" => radius,
        "filter[expand_university]" => false,
      ),
    )
  end

  def stub_suggested_without_salary_filter(radius:, number_of_results:)
    stub_courses(
      number_of_results: number_of_results,
      query: suggested_search_count_parameters.merge(
        "filter[latitude]" => 51.4980188,
        "filter[longitude]" => -0.1300436,
        "filter[radius]" => radius,
        "filter[expand_university]" => false,
      ),
    )
  end

  def search_for_salaried_courses_with_query_params(query)
    filter_page.load(query: query)
    filter_page.salary_courses.click
    filter_page.find_courses.click
  end

  before do
    stub_subjects
  end

  context "with 0 results" do
    context "and the initial search was filtered to a 50 mile radius" do
      before do
        stub_results_with_salary_filter(radius: 50, number_of_results: 0)
      end

      context "with courses available that are non-salaried with the same radius and salaried in a larger radius" do
        before do
          stub_suggested_without_salary_filter(radius: 50, number_of_results: 4)
          stub_suggested_across_england_with_salary_filter(number_of_results: 10)
        end

        it "displays a suggested search for the non-salaried courses with the same radius first followed with salaried in a larger radius" do
          search_for_salaried_courses_with_query_params(default_query_for_location_search(radius: 50))

          expect(results_page.suggested_search_heading.text).to eq("Suggested searches")
          expect(results_page.suggested_search_description.text).to eq("You can find:")
          expect(results_page.suggested_search_links.first.text).to eq("4 courses within 50 miles - including both salaried courses and ones without a salary")
          expect(results_page.suggested_search_links.first.link.text).to eq("4 courses within 50 miles")
          expect(results_page.suggested_search_links.last.text).to eq("10 courses across England with a salary")
        end
      end

      context "with courses available that are non-salaried with a larger radius and salaried in a larger radius" do
        before do
          stub_suggested_without_salary_filter(radius: 50, number_of_results: 0)
          stub_suggested_across_england_without_salary_filter(number_of_results: 4)
          stub_suggested_across_england_with_salary_filter(number_of_results: 10)
        end

        it "displays a suggested search for the non-salaried courses with the larger radius first followed with salaried in a larger radius" do
          search_for_salaried_courses_with_query_params(default_query_for_location_search(radius: 50))

          expect(results_page.suggested_search_heading.text).to eq("Suggested searches")
          expect(results_page.suggested_search_description.text).to eq("You can find:")
          expect(results_page.suggested_search_links.first.text).to eq("4 courses across England - including both salaried courses and ones without a salary")
          expect(results_page.suggested_search_links.first.link.text).to eq("4 courses across England")
          expect(results_page.suggested_search_links.last.text).to eq("10 courses across England with a salary")
        end
      end
    end
  end

  context "with more than 2 results" do
    before do
      stub_results_with_salary_filter(radius: 50, number_of_results: 10)
    end

    it "does not show the suggested searches" do
      search_for_salaried_courses_with_query_params(default_query_for_location_search(radius: 50))
      expect(results_page).not_to have_suggested_search_links
    end
  end
end
