module StubTeacherTrainingAPIHelper
  def stub_teacher_training_api_request(url_path, stub, method = :get, status = 200)
    url = "#{Settings.teacher_training_api.base_url}/api#{Settings.teacher_training_api.version}#{url_path}"

    stubbed_request = stub_request(method, url)
                        .to_return(
                          status: status,
                          body: stub.to_json,
                          headers: { 'Content-Type': 'application/vnd.api+json' },
                        )

    stubbed_request
  end

private

  def course_errors_to_json_api(course)
    errors = []
    course.errors.messages.each do |error_key, _|
      course.errors.full_messages_for(error_key).each do |error_message|
        errors << {
          'title' => "Invalid #{error_key}",
          'detail' => error_message,
          'source' => { 'pointer' => "/data/attributes/#{error_key}" },
        }
      end
    end
    errors
  end
end

RSpec.configure do |config|
  config.include StubTeacherTrainingAPIHelper
end
