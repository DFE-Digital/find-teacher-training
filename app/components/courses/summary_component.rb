module Courses
  class SummaryComponent < ViewComponent::Base
    include ApplicationHelper
    include ViewHelper

    attr_reader :course
    delegate :accrediting_provider,
             :provider,
             :funding_option,
             :age_range_in_years,
             :length,
             :applications_open_from,
             :outcome,
             :start_date, to: :course

    def initialize(course)
      @course = course
    end
  end
end
