require "rails_helper"

feature "Location filter back link", type: :feature do
  let(:filter_page) { PageObjects::Page::ResultFilters::Location.new }
  let(:provider_page) { PageObjects::Page::ResultFilters::ProviderPage.new }
  let(:results_page) { PageObjects::Page::Results.new }
  let(:base_parameters) { results_page_parameters }
  let(:courses_url) do
    "http://localhost:3001/api/v3/recruitment_cycles/2020/courses"
  end

  before do
    stub_results_page_request
    stub_subjects_request
  end

  context "before the location filter form has been submitted" do
    it "returns the user to their previous filtered results" do
      load_results_page
      open_the_location_filter
      click_the_back_link
      the_results_page_has_the_default_location_filter
    end
  end

  context "after an invalid postcode search has been submitted" do
    before do
      stub_provider_request
      stub_courses_request_with_acme
    end

    it "returns the user to their previous filtered results" do
      load_results_page
      open_the_location_filter
      select_a_provider

      open_the_change_provider_filter
      submit_an_invalid_postcode_filter
      click_the_back_link

      the_results_page_still_has_the_original_provider_filter_applied
    end
  end

  context "after an invalid provider search has been submitted" do
    before do
      stub_geocoder
      stub_courses_request_with_location
    end

    it "returns the user to their previous filtered results" do
      load_results_page
      open_the_location_filter
      select_a_location

      open_the_location_filter
      submit_an_invalid_provider_filter
      click_the_back_link

      the_results_page_still_has_the_original_location_filter_applied
    end
  end

  def load_results_page
    results_page.load
  end

  def open_the_location_filter
    results_page.location_filter.link.click
  end

  def open_the_change_provider_filter
    results_page.provider_filter.link.click
  end

  def select_a_provider
    filter_page.by_provider.click
    filter_page.provider_search.fill_in(with: "ACME")
    filter_page.find_courses.click
    provider_page.provider_suggestions[0].hyperlink.click
  end

  def submit_an_invalid_postcode_filter
    filter_page.by_postcode_town_or_city.click
    filter_page.find_courses.click
  end

  def click_the_back_link
    filter_page.back_link.click
  end

  def the_results_page_still_has_the_original_provider_filter_applied
    expect(results_page.provider_filter.name).to have_text("ACME SCITT 0")
  end

  def select_a_location
    filter_page.by_postcode_town_or_city.click
    filter_page.location_query.fill_in(with: "SW1P 3BT")
    filter_page.find_courses.click
  end

  def submit_an_invalid_provider_filter
    filter_page.by_provider.click
    filter_page.find_courses.click
  end

  def the_results_page_still_has_the_original_location_filter_applied
    expect(results_page.location_filter.name).to have_text("SW1P 3BT")
  end

  def the_results_page_has_the_default_location_filter
    expect(results_page.location_filter.name).to have_text("Across England")
  end

  def stub_provider_request
    stub_request(
      :get,
      "http://localhost:3001/api/v3/recruitment_cycles/2020/providers",
    ).with(
      query: {
        "fields[providers]" => "provider_code,provider_name",
        "search" => "ACME",
      },
    ).to_return(
      body: File.new("spec/fixtures/api_responses/providers.json"),
      headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
    )
  end

  def stub_results_page_request
    stub_request(:get, courses_url)
      .with(any_parameters)
      .to_return(
        body: File.new("spec/fixtures/api_responses/ten_courses.json"),
        headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
      )
  end

  def stub_courses_request_with_acme
    stub_request(:get, courses_url)
      .with(
        query: base_parameters.merge("filter[provider.provider_name]" => "ACME SCITT 0"),
      )
      .to_return(
        body: File.new("spec/fixtures/api_responses/four_courses.json"),
        headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
      )
  end

  def stub_courses_request_with_location
    stub_request(:get, courses_url)
      .with(
        query: base_parameters.merge(
          "filter[longitude]" => "-0.1300436",
          "filter[latitude]" => "51.4980188",
          "filter[radius]" => "20",
          "sort" => "distance",
        ),
      )
      .to_return(
        body: File.new("spec/fixtures/api_responses/ten_courses.json"),
        headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
      )
  end

  def any_parameters
    { query: hash_including({}) }
  end
end
