require "rails_helper"

describe Rack::HandleBadEncoding do
  let(:app) { double }
  let(:middleware) { described_class.new(app) }
  requests = [
    {
      path: "/location-suggestions",
      malformed_query: "query=%2Flondon%2bot%F",
    },
    {
      path: "/provider-suggestions",
      malformed_query: "query=%2FOxford%2bot%F",
    },
    {
      path: "/results",
      malformed_query: "?fulltime=false'&funding=8'&hasvacancies=true'&l=2'&page=10'&parttime=false'&qualifications%5B%5D=QtsOnly'&qualifications%5B%5D=PgdePgceWithQts'&qualifications%5B%5D=Other'&senCourses=false'&subjects%5B%5'%22'",
    },
  ]

  requests.each do |request|
    context "request path is #{request[:path]}" do
      context "query does not contain invalid encodings" do
        it "does not modify the query" do
          expect(app).to receive(:call).with("REQUEST_PATH" => request[:path], "QUERY_STRING" => "query=london")
          middleware.call(
            "REQUEST_PATH" => request[:path],
            "QUERY_STRING" => "query=london",
          )
        end
      end

      context "query is absent" do
        it "does not modify the query" do
          expect(app).to receive(:call).with("REQUEST_PATH" => request[:path])
          middleware.call("REQUEST_PATH" => request[:path])
        end
      end

      context "query contains invalid encodings" do
        it "modifies the query" do
          expect(app).to receive(:call).with(
            "QUERY_STRING" => "",
            "REQUEST_PATH" => request[:path],
          )
          middleware.call(
            "QUERY_STRING" => request[:malformed_query],
            "REQUEST_PATH" => request[:path],
          )
        end
      end
    end

    context "request path is not #{request[:path]}" do
      it "does not modify the query" do
        expect(app).to receive(:call).with(
          "QUERY_STRING" => request[:malformed_query],
          "REQUEST_PATH" => "/foo/bar",
        )
        middleware.call(
          "QUERY_STRING" => request[:malformed_query],
          "REQUEST_PATH" => "/foo/bar",
        )
      end
    end
  end
end
