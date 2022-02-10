require 'rails_helper'

describe LocationSuggestion do
  describe '.suggest' do
    let(:location1) { 'Cardiff, UK' }
    let(:location2) { 'Cardiff Road, Newport, UK' }
    let(:location3) { 'Cardiff House, Peckham Park Road, London, UK' }
    let(:query) { 'Cardiff' }
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
        language: 'en',
        input: query,
        components: 'country:uk',
        types: 'geocode',
      }.to_query
    end
    let(:url) { "#{Settings.google.places_api_host}#{Settings.google.places_api_path}?#{params}" }
    let(:location_suggestions) { suggest! }
    let(:query_stub) { stub_query(predictions: predictions) }

    def suggest!
      LocationSuggestion.suggest(query)
    end

    def stub_query(status: 200, predictions: [], error_message: nil)
      body = { predictions: predictions }
      body[:error_message] = error_message if error_message.present?

      stub_request(:get, url)
        .to_return(
          status: status,
          body: body.to_json,
          headers: { 'Content-Type': 'application/json' },
        )
    end

    context 'successful requests' do
      before do
        query_stub
        location_suggestions
      end

      it 'requests suggestions' do
        expect(query_stub).to have_been_requested
      end

      context 'successful request' do
        it 'returns the formatted result' do
          expect(location_suggestions.count).to eq(3)
          expect(location_suggestions.first).to eq('Cardiff')
          expect(location_suggestions.second).to eq('Cardiff Road, Newport')
          expect(location_suggestions.last).to eq('Cardiff House, Peckham Park Road, London')
        end
      end
    end

    context 'caching' do
      before { query_stub }

      it 'caches suggestions for a period of time' do
        result = suggest!
        expect(result.count).to eq 3
        expect(query_stub).to have_been_requested.once

        cached_result = suggest!
        expect(cached_result.count).to eq(3)
        expect(query_stub).to have_been_requested.once # no API call this time

        Timecop.travel(30.minutes.from_now) do
          subsequent_result = suggest!
          expect(subsequent_result.count).to eq(3)
          expect(query_stub).to have_been_requested.twice
        end
      end

      it 'caches nothing when the API returns an empty result' do
        stub_query(predictions: [])
        result = suggest!

        expect(result).to be_nil
        expect(Rails.cache.instance_variable_get(:@data)).to eq({})
      end

      it 'caches nothing when the API returns a bad HTTP status' do
        stub_query(status: 500)
        result = suggest!

        expect(result).to be_nil
        expect(Rails.cache.instance_variable_get(:@data)).to eq({})
      end

      it 'caches nothing when the API returns an error' do
        stub_query(error_message: 'Something went wrong')
        result = suggest!

        expect(result).to be_nil
        expect(Rails.cache.instance_variable_get(:@data)).to eq({})
      end
    end

    context 'with an error message in the body' do
      let(:error_message) { 'The provided API key is invalid.' }

      before do
        allow(Sentry).to receive(:capture_message)
        stub_query(error_message: error_message)
      end

      it 'sends a sentry error with the received error_message' do
        suggest!

        expect(Sentry).to have_received(:capture_message).with(
          "Google Places API error - status: 200, body: {\"predictions\"=>[], \"error_message\"=>\"#{error_message}\"}",
        )
      end
    end

    context 'unsuccessful request' do
      before do
        allow(Sentry).to receive(:capture_message)
        stub_query(status: 500)
      end

      it 'sends a sentry error' do
        suggest!

        expect(Sentry).to have_received(:capture_message).with(
          'Google Places API error - status: 500, body: {"predictions"=>[]}',
        )
      end
    end

    context 'suggestion limits' do
      before do
        predictions = []

        7.times do
          predictions.push(description: 'Foo')
        end

        stub_query(predictions: predictions)

        location_suggestions
      end

      it 'returns a maximum of 5 suggestions' do
        expect(location_suggestions.count).to eq(5)
      end
    end
  end
end
