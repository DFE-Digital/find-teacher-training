module StubbedRequests
  module Providers
    def stub_empty_providers(query: nil)
      stub_request(:get, providers_url)
        .with(query: query)
        .to_return(
          body: File.new('spec/fixtures/api_responses/empty_providers.json'),
          headers: { "Content-Type": 'application/vnd.api+json; charset=utf-8' },
        )
    end

    def stub_one_provider(query: nil)
      stub_request(:get, providers_url)
        .with(query: query)
        .to_return(
          body: File.new('spec/fixtures/api_responses/one_provider.json'),
          headers: { "Content-Type": 'application/vnd.api+json; charset=utf-8' },
        )
    end

    def stub_providers(query: nil)
      stub_request(:get, providers_url)
        .with(query: query)
        .to_return(
          body: File.new('spec/fixtures/api_responses/providers.json'),
          headers: { "Content-Type": 'application/vnd.api+json; charset=utf-8' },
        )
    end

    def providers_url
      "#{Settings.teacher_training_api.base_url}/api/v3/recruitment_cycles/#{RecruitmentCycle.current_year}/providers"
    end
  end
end
