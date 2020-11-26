require 'rails_helper'

describe Rack::HandleBadEncoding do
  include Rack::Test::Methods

  let(:app) { double }
  let(:middleware) { described_class.new(app) }

  before do
    allow(app).to receive(:call)
  end

  %w[/location-suggestions /provider-suggestions /results].each do |path|
    context "request path is #{path}" do
      context 'query does not contain invalid encodings' do
        it 'does not modify the query' do
          middleware.call(
            'REQUEST_PATH' => path,
            'QUERY_STRING' => 'query=london',
          )

          expect(app).to have_received(:call).with('REQUEST_PATH' => path, 'QUERY_STRING' => 'query=london')
        end
      end

      context 'query is absent' do
        it 'does not modify the query' do
          middleware.call('REQUEST_PATH' => path)

          expect(app).to have_received(:call).with('REQUEST_PATH' => path)
        end
      end

      context 'query contains invalid encodings' do
        it 'redirects to 422 page' do
          request = middleware.call(
            'QUERY_STRING' => 'query=%2Flondon%2bot%Forder%3Ddescending%26page%3D5%26sort%3Dcreated_at',
            'REQUEST_PATH' => path,
          )

          expect(request).to eq([301, { 'Location' => '/422', 'Content-Type' => 'text/html' }, []])
          expect(app).not_to have_received(:call)
        end
      end
    end
  end

  context "request path is not 'location-suggestions', '/provider-suggestions' or '/results'" do
    it 'does not modify the query' do
      middleware.call(
        'QUERY_STRING' => 'query=%2Flondon%2bot%Forder%3Ddescending%26page%3D5%26sort%3Dcreated_at',
        'REQUEST_PATH' => '/foo/bar',
      )

      expect(app).to have_received(:call).with(
        'QUERY_STRING' => 'query=%2Flondon%2bot%Forder%3Ddescending%26page%3D5%26sort%3Dcreated_at',
        'REQUEST_PATH' => '/foo/bar',
      )
    end
  end
end
