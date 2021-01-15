module StubbedRequests
  module Subjects
    def stub_subjects
      stub_request(
        :get,
        "#{Settings.teacher_training_api.base_url}/api/v3/subjects?fields%5Bsubjects%5D=subject_name,subject_code&sort=subject_name",
      ).to_return(
        body: File.new('spec/fixtures/api_responses/subjects_sorted_name_code.json'),
        headers: { "Content-Type": 'application/vnd.api+json; charset=utf-8' },
      )
    end
  end
end
