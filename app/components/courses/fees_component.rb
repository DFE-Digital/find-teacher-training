module Courses
  class FeesComponent < ViewComponent::Base
    include ApplicationHelper

    attr_reader :course

    delegate :fee_uk_eu,
             :fee_international,
             :year_range,
             :fee_details, to: :course

    def initialize(course)
      @course = course
    end
  end
end
