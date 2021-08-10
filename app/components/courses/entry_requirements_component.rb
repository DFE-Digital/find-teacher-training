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
        'An undergraduate degree at class 2:1 or above, or equivalent.'
      when 'two_two'
        'An undergraduate degree at class 2:2 or above, or equivalent.'
      when 'third_class'
        'An undergraduate degree, or equivalent. This should be an honours degree (Third or above), or equivalent.'
      when 'not_required'
        'An undergraduate degree, or equivalent.'
      end
    end

    def required_gcse_content(course)
      case course.level
      when 'primary'
        "Grade #{course.gcse_grade_required} (C) or above in English, maths and science, or equivalent qualification."
      when 'secondary'
        "Grade #{course.gcse_grade_required} (C) or above in English and maths, or equivalent qualification."
      end
    end

    def pending_gcse_content(course)
      if course.accept_pending_gcse
        'We will consider candidates with pending GCSEs.'
      else
        'We will not consider candidates with pending GCSEs.'
      end
    end

    def gcse_equivalency_content(course)
      if course.accept_gcse_equivalency?
        "We will accept equivalency tests in #{equivalencies}."
      else
        'We do not accept equivalency tests.'
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
