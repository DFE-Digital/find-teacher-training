module StubbedRequests
  module SubjectAreas
    def stub_subject_areas
      stub_request(
        :get,
        "#{Settings.teacher_training_api.base_url}/api/v3/subject_areas?include=subjects",
      ).to_return(
        body: File.new('spec/fixtures/api_responses/subject_areas.json'),
        headers: { "Content-Type": 'application/vnd.api+json; charset=utf-8' },
      )
    end
  end
end
