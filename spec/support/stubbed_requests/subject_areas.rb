module StubbedRequests
  module SubjectAreas
    def stub_subject_areas
      stub_request(
        :get,
        "#{Settings.teacher_training_api.base_url}/api#{Settings.teacher_training_api.version}/subject_areas?include=subjects",
      ).to_return(
        body: File.new('spec/fixtures/teacher_training_api/public/v1/subject_areas.json'),
        headers: { "Content-Type": 'application/vnd.api+json; charset=utf-8' },
      )
    end
  end
end
