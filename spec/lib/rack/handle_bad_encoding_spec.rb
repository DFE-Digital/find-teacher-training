require "rails_helper"

describe Rack::HandleBadEncoding do
  let(:app) { double }
  let(:middleware) { described_class.new(app) }

  %w[/location-suggestions /provider-suggestions].each do |path|
    context "request path is #{path}" do
      context "query does not contain invalid encodings" do
        it "does not modify the query" do
          expect(app).to receive(:call).with("REQUEST_PATH" => path, "QUERY_STRING" => "query=london")
          middleware.call(
            "REQUEST_PATH" => path,
            "QUERY_STRING" => "query=london",
          )
        end
      end

      context "query is absent" do
        it "does not modify the query" do
          expect(app).to receive(:call).with("REQUEST_PATH" => path)
          middleware.call("REQUEST_PATH" => path)
        end
      end

      context "query contains invalid encodings" do
        it "modifies the query" do
          expect(app).to receive(:call).with(
            "QUERY_STRING" => "",
            "REQUEST_PATH" => path,
          )
          middleware.call(
            "QUERY_STRING" => "query=%2Flondon%2bot%Forder%3Ddescending%26page%3D5%26sort%3Dcreated_at",
            "REQUEST_PATH" => path,
          )
        end
      end
    end
  end

  context "request path is not 'location-suggestions' or '/provider-suggestions'" do
    it "does not modify the query" do
      expect(app).to receive(:call).with(
        "QUERY_STRING" => "query=%2Flondon%2bot%Forder%3Ddescending%26page%3D5%26sort%3Dcreated_at",
        "REQUEST_PATH" => "/foo/bar",
      )
      middleware.call(
        "QUERY_STRING" => "query=%2Flondon%2bot%Forder%3Ddescending%26page%3D5%26sort%3Dcreated_at",
        "REQUEST_PATH" => "/foo/bar",
      )
    end
  end
end
