module Courses
  class EntryRequirementsComponent < ViewComponent::Base
    include ViewHelper

    attr_accessor :course

    def initialize(course:)
      @course = course
    end

  private

    def degree_grade_content(course)
      case course.degree_grade
      when 'two_one'
        '2:1 or above, or equivalent'
      when 'two_two'
        '2:2 or above, or equivalent'
      when 'third_class'
        'Third class degree or above, or equivalent'
      when 'not_required'
        'An undergraduate degree, or equivalent'
      end
    end

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
      if course.accept_gcse_equivalency?
        "Equivalency tests will be accepted in #{equivalencies}"
      else
        'Equivalency tests will not be accepted'
      end
    end

    def equivalencies
      subjects = []
      subjects << 'English' if course.accept_english_gcse_equivalency.present?
      subjects << 'maths' if course.accept_maths_gcse_equivalency.present?
      subjects << 'science' if course.accept_science_gcse_equivalency.present?

      subjects.to_sentence(last_word_connector: ' and ')
    end
  end
end
