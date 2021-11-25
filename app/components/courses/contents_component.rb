module Courses
  class ContentsComponent < ViewComponent::Base
    include ApplicationHelper
    include ViewHelper

    attr_reader :course

    delegate :about_course,
             :how_school_placements_work,
             :program_type,
             :provider,
             :about_accrediting_body,
             :salaried?,
             :interview_process, to: :course

    def initialize(course)
      @course = course
    end
  end
end
