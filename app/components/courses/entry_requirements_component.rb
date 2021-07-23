module Courses
  class EntryRequirementsComponent < ViewComponent::Base
    include ViewHelper

    def initialize(course:)
      @course = course
    end
  end
end
