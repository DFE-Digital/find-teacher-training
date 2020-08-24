require "rails_helper"

feature "Provider filter", type: :feature do
  let(:provider_filter_page) { PageObjects::Page::ResultFilters::ProviderPage.new }
  let(:location_filter_page) { PageObjects::Page::ResultFilters::Location.new }
  let(:results_page) { PageObjects::Page::Results.new }

  let(:courses_url) do
    "http://localhost:3001/api/v3/recruitment_cycles/2020/courses"
  end

  let(:providers_url) do
    "http://localhost:3001/api/v3/recruitment_cycles/2020/providers?fields%5Bproviders%5D=provider_code,provider_name&search=#{search_term}"
  end

  let(:base_parameters) { results_page_parameters }

  let(:search_term) { "ACME" }
  let(:query_params) { { query: search_term } }

  before do
    stub_subjects_request

    stub_request(:get, courses_url)
      .with(
        query: base_parameters.merge(
          "filter[provider.provider_name]" => "ACME SCITT 0",
        ),
      ).to_return(
        body: File.new("spec/fixtures/api_responses/ten_courses.json"),
        headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
      )
  end

  context "with an empty search" do
    let(:query_params) { "   " }

    before do
      provider_filter_page.load(query: query_params)
    end

    it "Displays an error if provider search is selected but empty" do
      expect(location_filter_page).to have_error
    end

    it "Does not include the query parameter in the params" do
      expect(Rack::Utils.parse_nested_query(URI(current_url).query)).to eq({})
    end
  end

  context "with a query" do
    context "with many providers" do
      before do
        stub_request(:get, providers_url)
          .to_return(
            body: File.new("spec/fixtures/api_responses/providers.json"),
            headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
          )

        provider_filter_page.load(query: query_params)
      end

      it "queries the API" do
        expect(provider_filter_page.provider_suggestions.first.hyperlink.text).to eq("ACME SCITT 0 (A0)")
        expect(provider_filter_page.provider_suggestions.second.hyperlink.text).to eq("ACME SCITT 1 (A1)")
      end

      it "links to the results page" do
        provider_filter_page.provider_suggestions.first.hyperlink.click
        expect_page_to_be_displayed_with_query(
          page: results_page,
          expected_query_params: {
            "query" => "ACME SCITT 0",
          },
        )
      end

      context "with existing params" do
        let(:query_params) { { other_param: "my other param", query: "ACME" } }

        it "preserves previous parameters" do
          provider_filter_page.provider_suggestions.first.hyperlink.click
          # We must do this because site_prism's URL system is broken
          expect(results_page.url).to eq(current_path)
          expect(Rack::Utils.parse_nested_query(URI(current_url).query)).to eq(
            "other_param" => "my other param",
            "query" => "ACME SCITT 0",
          )
        end
      end
    end

    context "with only one provider" do
      before do
        stub_request(:get, providers_url)
          .to_return(
            body: File.new("spec/fixtures/api_responses/one_provider.json"),
            headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
          )

        provider_filter_page.load(query: query_params)
      end

      it "is automatically selected" do
        expect(results_page.url).to eq(current_path)
        expect(Rack::Utils.parse_nested_query(URI(current_url).query)).to eq(
          "query" => "ACME SCITT 0",
        )
      end
    end

    context "with no providers" do
      before do
        stub_request(:get, providers_url)
          .to_return(
            body: File.new("spec/fixtures/api_responses/empty_providers.json"),
            headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
          )

        provider_filter_page.load(query: query_params)
      end

      it "redirects to location page with an error" do
        expect(current_path).to eq(location_filter_page.url)
        expect(Rack::Utils.parse_nested_query(URI(current_url).query)).to eq("query" => "ACME")
        expect(location_filter_page.error_text.text).to eq("Training provider")
        expect(location_filter_page.provider_error.text).to eq("Error: We couldn’t find this provider, please check your information and try again")
      end
    end
  end

  context "Searching" do
    let(:search_term) { "ACME SCITT" }
    before do
      stub_request(:get, providers_url)
        .to_return(
          body: File.new("spec/fixtures/api_responses/providers.json"),
          headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
        )

      provider_filter_page.load(query: query_params)
    end
    it "has a form with which to search again" do
      provider_filter_page.search_expand.click
      provider_filter_page.search_input.fill_in(with: "ACME SCITT")
      provider_filter_page.search_submit.click

      expect(current_path).to eq(provider_filter_page.url)
      expect(Rack::Utils.parse_nested_query(URI(current_url).query)).to eq(
        "query" => "ACME SCITT",
        "utf8" => "✓",
      )
    end
  end
end
