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

    def initialize(course:, filtered_by_location:, has_sites:)
      @course = course
      @filtered_by_location = filtered_by_location
      @has_sites = has_sites
    end
  end
end
