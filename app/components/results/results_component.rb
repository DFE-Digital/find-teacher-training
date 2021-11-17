module Results
  class ResultsComponent < ViewComponent::Base
    include ViewHelper

    attr_reader :results, :courses

    def initialize(results:, courses:)
      @results = results
      @courses = courses
    end
  end
end
