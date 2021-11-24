module Courses
  class QualificationsSummaryComponent < ViewComponent::Base
    include ApplicationHelper
    include ViewHelper

    attr_reader :outcome

    def initialize(outcome)
      @outcome = outcome
    end
  end
end
