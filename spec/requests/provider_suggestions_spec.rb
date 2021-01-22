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
        provider_suggestions = stub_provider_suggestions(
          query: {
            'fields[provider_suggestions]' => 'code,name',
            'filter[recruitment_cycle_year]' => Settings.current_cycle,
            'query' => provider_query,
          },
        )

        get "/provider-suggestions?query=#{provider_query}"

        expect(provider_suggestions).to have_been_requested
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq(
          [
            {
              'code' => 'O66',
              'name' => 'Oxford Brookes University',
            },
            {
              'code' => 'O33',
              'name' => 'Oxford University',
            },
            {
              'code' => '1DE',
              'name' => 'Oxfordshire Teacher Training',
            },
          ],
        )
      end
    end
  end
end
