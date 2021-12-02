module Courses
  class ApplyComponent < ViewComponent::Base
    attr_reader :course

    delegate :has_vacancies?, :provider, to: :course

    def initialize(course)
      @course = course
    end
  end
end
