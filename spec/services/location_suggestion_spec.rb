require "rails_helper"

describe LocationSuggestion do
  describe "#suggest" do
    let(:location1) { "Cardiff, UK" }
    let(:location2) { "Cardiff Road, Newport, UK" }
    let(:location3) { "Cardiff House, Peckham Park Road, London, UK" }
    let(:query) { "Cardiff" }
    let(:predictions) do
      [
        { description: location1 },
        { description: location2 },
        { description: location3 },
      ]
    end
    let(:params) do
      {
        key: Settings.google.gcp_api_key,
        language: "en",
        input: query,
        components: "country:uk",
        types: "geocode",
      }.to_query
    end
    let(:url) { "#{Settings.google.places_api_host}#{Settings.google.places_api_path}?#{params}" }

    let(:location_suggestions) do
      LocationSuggestion.suggest(query)
    end

    let(:query_stub) do
      stub_suggestions(200, predictions)
    end

    def stub_suggestions(status, stub = {})
      stub_request(:get, url)
        .to_return(
          status: status,
          body: { predictions: stub }.to_json,
          headers: { 'Content-Type': "application/json" },
        )
    end

    context "successful requests" do
      before do
        query_stub
        location_suggestions
      end

      it "requests suggestions" do
        expect(query_stub).to have_been_requested
      end

      context "successful request" do
        it "returns the formatted result" do
          expect(location_suggestions.count).to eq(3)
          expect(location_suggestions.first).to eq("Cardiff")
          expect(location_suggestions.second).to eq("Cardiff Road, Newport")
          expect(location_suggestions.last).to eq("Cardiff House, Peckham Park Road, London")
        end
      end
    end

    context "suggestion limits" do
      before do
        predictions = []

        7.times do
          predictions.push(description: "Foo")
        end

        stub_suggestions(200, predictions)

        location_suggestions
      end

      it "it returns a maximum of 5 suggestions" do
        expect(location_suggestions.count).to eq(5)
      end
    end

    context "unsuccessful request" do
      before do
        stub_suggestions(500)
      end

      it "returns nothing" do
        expect(location_suggestions).to be_nil
      end
    end
  end
end
