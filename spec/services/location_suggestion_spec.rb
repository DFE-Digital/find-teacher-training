require "rails_helper"

describe LocationSuggestion do
  describe "#suggest" do
    let(:location1) { "123 Seseme Street" }
    let(:location2) { "New York, NY" }
    let(:query) { "New York" }
    let(:predictions) {
      [
        { description: location1 },
        { description: location2 },
      ]
    }
    let(:params) {
      {
        key: Settings.gcp_api_key,
        language: "en",
        input: query,
        components: "country:uk",
        types: "geocode",
      }.to_query
    }
    let(:url) { "https://maps.googleapis.com/maps/api/place/autocomplete/json?#{params}" }

    let(:location_suggestions) do
      LocationSuggestion.suggest(query)
    end

    let(:query_stub) {
      stub_suggestions(200, predictions)
    }

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
        it "returns the result" do
          expect(location_suggestions.count).to eq(2)
          expect(location_suggestions.first).to eq(location1)
          expect(location_suggestions.last).to eq(location2)
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
