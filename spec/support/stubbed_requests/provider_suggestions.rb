module StubbedRequests
  module ProviderSuggestions
    def stub_provider_suggestions(query:)
      stub_request(:get, "#{Settings.teacher_training_api.base_url}/api/v3/provider-suggestions?query=#{query}")
        .to_return(
          headers: { "Content-Type": 'application/vnd.api+json; charset=utf-8' },
          body: File.new('spec/fixtures/api_responses/provider-suggestions.json'),
        )
    end
  end
end
