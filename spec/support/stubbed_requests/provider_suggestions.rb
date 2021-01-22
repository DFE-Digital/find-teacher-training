module StubbedRequests
  module ProviderSuggestions
    def stub_provider_suggestions(query:)
      stub_request(:get, provider_suggestions_url)
        .with(query: query)
        .to_return(
          headers: { "Content-Type": 'application/vnd.api+json; charset=utf-8' },
          body: File.new('spec/fixtures/teacher_training_api/public/v1/provider_suggestions.json'),
        )
    end

    def stub_one_provider_suggestion(query:)
      stub_request(:get, provider_suggestions_url)
        .with(query: query)
        .to_return(
          headers: { "Content-Type": 'application/vnd.api+json; charset=utf-8' },
          body: File.new('spec/fixtures/teacher_training_api/public/v1/one_provider_suggestion.json'),
        )
    end

    def stub_empty_provider_suggestions(query: nil)
      stub_request(:get, provider_suggestions_url)
        .with(query: query)
        .to_return(
          body: File.new('spec/fixtures/teacher_training_api/public/v1/empty_response.json'),
          headers: { "Content-Type": 'application/vnd.api+json; charset=utf-8' },
        )
    end

    def provider_suggestions_url
      "#{Settings.teacher_training_api.base_url}/api#{Settings.teacher_training_api.version}/provider_suggestions"
    end
  end
end
