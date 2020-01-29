require "rails_helper"

feature "Provider filter", :focus, type: :feature do
  let(:provider_filter_page) { PageObjects::Page::ResultFilters::ProviderPage.new }
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
      search: "ACME",
    )
  end

  let(:query_params) { {} }
  before do
    stub_results_page_request

    provider_request

    provider_filter_page.load(query: query_params)
  end

  context "with a query" do
    it "queries the backend" do
      expect(provider_filter_page.provider_suggestions.first.submit.value).to eq("#{providers.first.provider_name} (#{providers.first.provider_code})")
      expect(provider_filter_page.provider_suggestions.second.submit.value).to eq("#{providers.second.provider_name} (#{providers.second.provider_code})")
    end

    it "links to the results page" do
      provider_filter_page.provider_suggestions.first.submit.click
      expect_page_to_be_displayed_with_query(
        page: results_page,
        expected_query_params: {
          "query" => "ACME SCITT 2",
        },
      )
    end

    context "with existing params" do
      let(:query_params) { { other_param: "my other param" } }

      it "preserves previous parameters" do
        provider_filter_page.provider_suggestions.first.submit.click
        expect_page_to_be_displayed_with_query(
          page: results_page,
          expected_query_params: {
            "other_param" => "my other param",
            "query" => "ACME SCITT 2",
          },
        )
      end
    end
  end
end
