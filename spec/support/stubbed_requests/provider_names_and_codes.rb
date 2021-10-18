module StubbedRequests
  module ProviderNamesAndCodes
    def stub_teacher_training_api_provider_names_and_codes(recruitment_cycle_year: RecruitmentCycle.current_year)
      scope = stub_request(
        :get,
        "#{Settings.teacher_training_api.base_url}/api/v3/recruitment_cycles/#{recruitment_cycle_year}/providers?fields[providers]=provider_code,provider_name",
      )

      scope.to_return(
        status: 200,
        headers: { 'Content-Type': 'application/vnd.api+json' },
        body: File.new('spec/fixtures/api_responses/provider_names_and_codes.json'),
      )
    end

    def stub_teacher_training_api_provider_names_and_codes_timeout(recruitment_cycle_year: RecruitmentCycle.current_year)
      stub_request(
        :get,
        "#{Settings.teacher_training_api.base_url}/api/v3/recruitment_cycles/#{recruitment_cycle_year}/providers?fields[providers]=provider_code,provider_name",
      ).to_timeout
    end
  end
end
