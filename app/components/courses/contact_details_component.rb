module Courses
  class ContactDetailsComponent < ViewComponent::Base
    attr_reader :course

    delegate :provider, to: :course

    def initialize(course)
      @course = course
    end
  end
end
