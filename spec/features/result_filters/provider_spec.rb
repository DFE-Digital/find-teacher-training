require "rails_helper"

feature "Provider filter", type: :feature do
  let(:provider_filter_page) { PageObjects::Page::ResultFilters::ProviderPage.new }
  let(:location_filter_page) { PageObjects::Page::ResultFilters::Location.new }
  let(:results_page) { PageObjects::Page::Results.new }

  let(:providers) do
    [
      build(:provider, provider_name: "ACME SCITT 2", provider_code: "2"),
      build(:provider, provider_name: "ACME SCITT 3", provider_code: "3"),
    ]
  end

  let(:provider_request) do
    stub_api_v3_resource(
      type: Provider,
      resources: providers,
      fields: { providers: %i[provider_code provider_name] },
      params: { recruitment_cycle_year: 2020 },
      search: search_term,
    )
  end

  let(:search_term) { "ACME" }
  let(:query_params) { { query: search_term } }

  before do
    stub_results_page_request

    provider_request

    provider_filter_page.load(query: query_params)
  end

  context "with an empty search" do
    let(:query_params) { "   " }

    it "Displays an error if provider search is selected but empty" do
      expect(location_filter_page).to have_error
    end

    it "Does not include the query parameter in the params" do
      expect(Rack::Utils.parse_nested_query(URI(current_url).query)).to eq({})
    end
  end

  context "with a query" do
    it "queries the backend" do
      expect(provider_filter_page.provider_suggestions.first.hyperlink.text).to eq("#{providers.first.provider_name} (#{providers.first.provider_code})")
      expect(provider_filter_page.provider_suggestions.second.hyperlink.text).to eq("#{providers.second.provider_name} (#{providers.second.provider_code})")
    end

    it "links to the results page" do
      provider_filter_page.provider_suggestions.first.hyperlink.click
      expect_page_to_be_displayed_with_query(
        page: results_page,
        expected_query_params: {
          "query" => "ACME SCITT 2",
        },
      )
    end

    context "with existing params" do
      let(:query_params) { { other_param: "my other param", query: "ACME" } }

      it "preserves previous parameters" do
        provider_filter_page.provider_suggestions.first.hyperlink.click
        #We must do this because site_prism's URL system is broken
        expect(results_page.url).to eq(current_path)
        expect(Rack::Utils.parse_nested_query(URI(current_url).query)).to eq(
          "other_param" => "my other param",
          "query" => "ACME SCITT 2",
        )
      end
    end

    context "with only one provider" do
      let(:providers) do
        [
          build(:provider, provider_name: "ACME SCITT 4", provider_code: "4"),
        ]
      end

      it "is automatically selected" do
        expect(results_page.url).to eq(current_path)
        expect(Rack::Utils.parse_nested_query(URI(current_url).query)).to eq(
          "query" => "ACME SCITT 4",
        )
      end
    end

    context "with no providers" do
      let(:providers) do
        []
      end

      it "redirects to location page with an error" do
        expect(current_path).to eq(location_filter_page.url)
        expect(Rack::Utils.parse_nested_query(URI(current_url).query)).to eq(
          "query" => "ACME",
        )
        expect(location_filter_page.error_text.text).to eq("Training provider")
        expect(location_filter_page.provider_error.text).to eq("Error: Please enter the name of a training provider")
      end
    end
  end

  it "has a form with which to search again" do
    stub_api_v3_resource(
      type: Provider,
      resources: providers,
      fields: { providers: %i[provider_code provider_name] },
      params: { recruitment_cycle_year: 2020 },
      search: "ACME SCITT",
    )

    provider_filter_page.search.expand.click
    provider_filter_page.search.input.fill_in(with: "ACME SCITT")
    provider_filter_page.search.submit.click

    expect(current_path).to eq(provider_filter_page.url)
    expect(Rack::Utils.parse_nested_query(URI(current_url).query)).to eq(
      "query" => "ACME SCITT",
      "utf8" => "✓",
    )
  end
end
