require "rails_helper"

describe "heartbeat requests" do
  describe "GET /ping" do
    it "returns PONG" do
      get "/ping"

      expect(response.body).to eq "PONG"
    end
  end

  describe "GET /healthcheck" do
    let(:healthcheck_endpoint) { "http://localhost:3001/healthcheck" }

    context "when everything is ok" do
      before do
        stub_request(:get, healthcheck_endpoint)
            .to_return(status: 200)
        get "/healthcheck"
      end

      it "returns HTTP success" do
        expect(response.status).to eq(200)
      end

      it "returns JSON" do
        expect(response.content_type).to eq("application/json")
      end

      it "returns the expected response report" do
        expect(response.body).to eq({ checks: {
            teacher_training_api: true,
        } }.to_json)
      end
    end

    context "when the api returns 502" do
      before do
        stub_request(:get, healthcheck_endpoint)
            .to_return(status: 502)
        get "/healthcheck"
      end

      it "returns status bad gateway" do
        expect(response.status).to eq(502)
      end

      it "returns the expected response report" do
        expect(response.body).to eq({ checks: {
          teacher_training_api: false,
        } }.to_json)
      end
    end

    context "when the api times out" do
      before do
        stub_request(:get, healthcheck_endpoint)
            .to_timeout
        get "/healthcheck"
      end

      it "returns status bad gateway" do
        expect(response.status).to eq(502)
      end

      it "returns the expected response report" do
        expect(response.body).to eq({ checks: {
          teacher_training_api: false,
        } }.to_json)
      end
    end

    context "when the api refuses the connection" do
      before do
        stub_request(:get, healthcheck_endpoint)
            .to_raise(StandardError) # https://stackoverflow.com/questions/25552239/webmock-simulate-failing-api-no-internet-timeout/25559291#25559291
        get "/healthcheck"
      end

      it "returns status bad gateway" do
        expect(response.status).to eq(502)
      end

      it "returns the expected response report" do
        expect(response.body).to eq({ checks: {
          teacher_training_api: false,
        } }.to_json)
      end
    end
  end
end
