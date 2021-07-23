module Courses
  class EntryRequirementsComponent < ViewComponent::Base
    include ViewHelper

    attr_accessor :course

    def initialize(course:)
      @course = course
    end

private

    def required_gcse_content(course)
      case course.level
      when 'primary'
        "Grade #{course.gcse_grade_required} (C) or above in English, maths and science, or equivalent qualification"
      when 'secondary'
        "Grade #{course.gcse_grade_required} (C) or above in English and maths, or equivalent qualification"
      end
    end

    def pending_gcse_content(course)
      if course.accept_pending_gcse
        'Candidates with pending GCSEs will be considered'
      else
        'Candidates with pending GCSEs will not be considered'
      end
    end

    def gcse_equivalency_content(course)
      return 'Equivalency tests will not be accepted' unless course.accept_gcse_equivalency

      case equivalencies.count
      when 0
        ''
      when 1
        "Equivalency tests will be accepted in #{equivalencies[0].capitalize}"
      when 2
        "Equivalency tests will be accepted in #{equivalencies[0].capitalize} and #{equivalencies[1]}"
      when 3
        "Equivalency tests will be accepted in #{equivalencies[0].capitalize}, #{equivalencies[1]} and #{equivalencies[2]}"
      end
    end

    def equivalencies
      {
        english: course.accept_english_gcse_equivalency.present?,
        maths: course.accept_maths_gcse_equivalency.present?,
        science: course.accept_science_gcse_equivalency.present?,

      }.select { |_k, v| v }.keys
    end
  end
end
