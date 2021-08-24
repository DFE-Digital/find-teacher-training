module Courses
  class SearchResultComponent < ViewComponent::Base
    include ViewHelper

    attr_reader :course

    def filtered_by_location?
      @filtered_by_location
    end

    def has_sites?
      @has_sites
    end

    def initialize(course:, filtered_by_location: false, has_sites: false)
      @course = course
      @filtered_by_location = filtered_by_location
      @has_sites = has_sites
    end

    def degree_required
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
  end
end
