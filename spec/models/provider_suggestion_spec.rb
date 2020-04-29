require "rails_helper"

describe ProviderSuggestion do
  describe "#suggest" do
    let(:provider_suggestion1) { build(:provider_suggestion) }
    let(:provider_suggestion2) { build(:provider_suggestion) }
    let(:query_stub) do
      stub_suggestion("query", resource_list_to_jsonapi([provider_suggestion1, provider_suggestion2]))
    end
    let(:provider_suggestions) do
      ProviderSuggestion.suggest("query")
    end

    def stub_suggestion(query, stub)
      stub_api_v3_request(
        "/provider-suggestions?query=#{query}",
        stub,
      )
    end

    before do
      query_stub
      provider_suggestions
    end

    it "requests suggestions" do
      expect(query_stub).to have_been_requested
    end

    it "returns the result" do
      expect(provider_suggestions.length).to eq(2)

      expect(provider_suggestions.first.attributes[:type]).to eq("provider_suggestion")
      expect(provider_suggestions.first.attributes[:provider_code]).to eq(provider_suggestion1.provider_code)
      expect(provider_suggestions.first.attributes[:provider_name]).to eq(provider_suggestion1.provider_name)

      expect(provider_suggestions.second.attributes[:type]).to eq("provider_suggestion")
      expect(provider_suggestions.second.attributes[:provider_code]).to eq(provider_suggestion2.provider_code)
      expect(provider_suggestions.second.attributes[:provider_name]).to eq(provider_suggestion2.provider_name)
    end
  end
end
