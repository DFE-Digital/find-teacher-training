require "rails_helper"

describe "/provider-suggestions", type: :request do
  context "when provider suggestion is blank" do
    it "returns bad request (400)" do
      get "/provider-suggestions"

      expect(response.status).to eq(400)
      expect(JSON.parse(response.body)).to eq("error" => "Bad request")
    end
  end
  context "when provider suggestion is less than three characters" do
    it "returns bad request (400)" do
      get "/provider-suggestions?query=St"

      expect(response.status).to eq(400)
      expect(JSON.parse(response.body)).to eq("error" => "Bad request")
    end
  end
  context "when provider suggestion ids valid" do
    let(:provider_suggestions) {
      stub_request(:get, "#{Settings.teacher_training_api.base_url}/api/v3/provider-suggestions?query=Str")
        .to_return(
          headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
          body: File.new("spec/fixtures/api_responses/provider-suggestions.json"),
        )
    }

    before do
      provider_suggestions
    end

    it "returns success (200)" do
      get "/provider-suggestions?query=Str"

      expect(provider_suggestions).to have_been_requested
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq(
        [
           {
             "code" => "A0",
             "name" => "ACME SCITT 0",
           },
           {
             "code" => "A01",
             "name" => "Acme SCITT",
           },
         ],
       )
    end
  end
end
