require "rails_helper"

feature "suggested searches", type: :feature do
  let(:filter_page) { PageObjects::Page::ResultFilters::Location.new }
  let(:results_page) { PageObjects::Page::Results.new }
  let(:sort) { "distance" }
  let(:base_parameters) { results_page_parameters("sort" => sort) }

  def suggested_search_count_parameters
    base_parameters.reject do |k, _v|
      ["page[page]", "page[per_page]", "sort"].include?(k)
    end
  end

  before do
    stub_geocoder

    stub_subjects_request
  end

  def results_page_request(radius:, results_to_return:)
    stub_request(:get, courses_url)
      .with(query: base_parameters.merge(
        "filter[latitude]" => 51.4980188,
        "filter[longitude]" => -0.1300436,
        "filter[radius]" => radius,
        "filter[expand_university]" => false,
      ))
      .to_return(
        body: course_fixture_for(results: results_to_return),
        headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
      )
  end

  def across_england_results_page_request(results_to_return:)
    stub_request(:get, courses_url)
      .with(query: base_parameters)
      .to_return(
        body: course_fixture_for(results: results_to_return),
        headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
      )
  end

  def suggested_search_count_request(radius:, results_to_return:)
    stub_request(:get, courses_url)
      .with(query: suggested_search_count_parameters.merge(
        "filter[latitude]" => 51.4980188,
        "filter[longitude]" => -0.1300436,
        "filter[radius]" => radius,
        "filter[expand_university]" => false,
      ))
      .to_return(
        body: course_fixture_for(results: results_to_return),
        headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
      )
  end

  def suggested_search_count_across_england(results_to_return:)
    stub_request(:get, courses_url)
      .with(query: suggested_search_count_parameters)
      .to_return(
        body: course_fixture_for(results: results_to_return),
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

  context "when an initial search returns no results" do
    context "when the search was filtered to the default 50 mile radius" do
      before do
        results_page_request(radius: 50, results_to_return: 0)
        suggested_search_count_across_england(results_to_return: 10)
        across_england_results_page_request(results_to_return: 10)
      end

      it "shows links for expanded across England search that would return more results" do
        filter_page.load
        filter_page.by_postcode_town_or_city.click
        filter_page.location_query.set "SW1P 3BT"

        filter_page.find_courses.click

        expect(results_page.suggested_search_heading.text).to eq("Suggested searches")
        expect(results_page.suggested_search_description.text).to eq("You can find:")
        expect(results_page.suggested_search_links.first.text).to eq("10 courses across England")

        results_page.suggested_search_links.first.link.click

        expect(results_page.courses.count).to eq(10)
      end
    end

    context "no courses are found in the suggested searches" do
      before do
        results_page_request(radius: 50, results_to_return: 0)
        suggested_search_count_across_england(results_to_return: 0)
      end

      it "doesn't show the link if there are no courses found" do
        filter_page.load
        filter_page.by_postcode_town_or_city.click
        filter_page.location_query.set "SW1P 3BT"

        filter_page.find_courses.click
        expect(results_page).not_to have_suggested_search_links
      end
    end

    context "there are no results in any suggested searches" do
      before do
        results_page_request(radius: 50, results_to_return: 0)
        suggested_search_count_across_england(results_to_return: 0)
      end

      it "doesn't show the suggested searches section" do
        filter_page.load
        filter_page.by_postcode_town_or_city.click
        filter_page.location_query.set "SW1P 3BT"

        filter_page.find_courses.click
        expect(results_page).not_to have_suggested_searches
      end
    end
  end

  context "a search with more than 3 results" do
    before do
      results_page_request(radius: 50, results_to_return: 10)
    end

    it "shows no links" do
      filter_page.load
      filter_page.by_postcode_town_or_city.click
      filter_page.location_query.set "SW1P 3BT"

      filter_page.find_courses.click
      expect(results_page).not_to have_suggested_search_links
    end
  end

  context "a search filtered by provider with 2 results" do
    before do
      stub_request(
        :get,
        "#{Settings.teacher_training_api.base_url}/api/v3/recruitment_cycles/#{Settings.current_cycle}/providers",
      ).with(
        query: {
          "fields[providers]" => "provider_code,provider_name",
          "search" => "ACME",
        },
      ).to_return(
        body: File.new("spec/fixtures/api_responses/providers.json"),
        headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
      )

      stub_request(:get, courses_url)
        .with(
          query: base_parameters.merge("filter[provider.provider_name]" => "ACME SCITT 0"),
        )
        .to_return(
          body: File.new("spec/fixtures/api_responses/two_courses.json"),
          headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
        )
    end

    it "doesn't show suggested searches" do
      filter_page.load
      filter_page.by_provider.click
      filter_page.provider_search.fill_in(with: "ACME")
      filter_page.find_courses.click

      expect(results_page).not_to have_suggested_search_links
    end
  end
end
