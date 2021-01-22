module StubbedRequests
  module Subjects
    def stub_subjects
      stub_request(
        :get,
        "#{Settings.teacher_training_api.base_url}/api#{Settings.teacher_training_api.version}/subjects?fields%5Bsubjects%5D=name,code&sort=name",
      ).to_return(
        body: File.new('spec/fixtures/teacher_training_api/public/v1/subjects_sorted.json'),
        headers: { "Content-Type": 'application/vnd.api+json; charset=utf-8' },
      )
    end
  end
end
