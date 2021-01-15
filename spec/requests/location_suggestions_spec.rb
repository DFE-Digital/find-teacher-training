require 'rails_helper'

describe '/location-suggestions', type: :request do
  include StubbedRequests::LocationSuggestions

  context 'when provider suggestion is blank' do
    it 'returns bad request (400)' do
      get '/location-suggestions'

      expect(response.status).to eq(400)
      expect(JSON.parse(response.body)).to eq('error' => 'Bad request')
    end
  end

  context 'when location suggestion query is valid' do
    it 'returns success (200)' do
      query = 'london'
      location_suggestions = stub_location_suggestions(query: query)
      get "/location-suggestions?query=#{query}"

      expect(location_suggestions).to have_been_requested
      expect(response.status).to eq(200)
    end
  end
end
