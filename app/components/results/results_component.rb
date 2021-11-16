module Results
  class ResultsComponent < ViewComponent::Base
    include ViewHelper

    attr_reader :results_view, :courses

    def initialize(results_view:, courses:)
      @results_view = results_view
      @courses = courses
    end
  end
end
