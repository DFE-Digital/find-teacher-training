module Courses
  class NoResultsComponent < ViewComponent::Base
    include ViewHelper

    attr_reader :results
    delegate :devolved_nation?, :country, :subjects, :with_salaries?, to: :results

    def initialize(results:)
      @results = results
    end
  end
end
