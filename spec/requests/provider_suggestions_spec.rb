require 'rails_helper'

describe '/provider-suggestions', type: :request do
  include StubbedRequests::ProviderSuggestions

  context 'when provider suggestion is blank' do
    it 'returns bad request (400)' do
      get '/provider-suggestions'

      expect(response.status).to eq(400)
      expect(JSON.parse(response.body)).to eq('error' => 'Bad request')
    end
  end

  context 'when provider suggestion is less than three characters' do
    it 'returns bad request (400)' do
      get '/provider-suggestions?query=St'

      expect(response.status).to eq(400)
      expect(JSON.parse(response.body)).to eq('error' => 'Bad request')
    end
  end

  context 'when provider suggestion query is valid' do
    query = 'Str'
    query_with_unicode_character = 'Str%E2%80%99'

    [query, query_with_unicode_character].each do |provider_query|
      it "returns success (200) for query: '#{provider_query}'" do
        provider_suggestions = stub_provider_suggestions(query: provider_query)

        get "/provider-suggestions?query=#{provider_query}"

        expect(provider_suggestions).to have_been_requested
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq(
          [
            {
              'code' => 'A0',
              'name' => 'ACME SCITT 0',
            },
            {
              'code' => 'A01',
              'name' => 'Acme SCITT',
            },
          ],
        )
      end
    end
  end
end
