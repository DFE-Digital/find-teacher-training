module StubbedRequests
  module Providers
    def stub_empty_providers(query: nil)
      stub_request(:get, providers_url)
        .with(query: query)
        .to_return(
          body: File.new('spec/fixtures/teacher_training_api/public/v1/empty_providers.json'),
          headers: { "Content-Type": 'application/vnd.api+json; charset=utf-8' },
        )
    end

    def stub_one_provider(query: nil)
      stub_request(:get, providers_url)
        .with(query: query)
        .to_return(
          body: File.new('spec/fixtures/teacher_training_api/public/v1/one_provider.json'),
          headers: { "Content-Type": 'application/vnd.api+json; charset=utf-8' },
        )
    end

    def stub_providers(query: nil)
      stub_request(:get, providers_url)
        .with(query: query)
        .to_return(
          body: File.new('spec/fixtures/teacher_training_api/public/v1/providers.json'),
          headers: { "Content-Type": 'application/vnd.api+json; charset=utf-8' },
        )
    end

    def providers_url
      "#{Settings.teacher_training_api.base_url}/api#{Settings.teacher_training_api.version}/recruitment_cycles/#{Settings.current_cycle}/providers"
    end
  end
end
