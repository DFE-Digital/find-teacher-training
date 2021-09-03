module StubbedRequests
  module Courses
    def stub_courses(query:, course_count:)
      fixture_file = course_fixture(course_count)
      stub_request(:get, courses_url)
        .with(query: query)
        .to_return(
          body: File.new("spec/fixtures/api_responses/#{fixture_file}"),
          headers: { "Content-Type": 'application/vnd.api+json; charset=utf-8' },
        )
    end

    def course_fixture(course_count)
      case course_count
      when 0
        'empty_courses.json'
      when 1
        'one_course.json'
      when 2
        'two_courses.json'
      when 4
        'four_courses.json'
      when 10
        'ten_courses.json'
      end
    end

    def courses_url
      "#{Settings.teacher_training_api.base_url}/api/v3/recruitment_cycles/#{CycleTimetable.current_year}/courses"
    end
  end
end
