module Courses
  class FeesAndFinancialSupportComponent < ViewComponent::Base
    include ApplicationHelper
    include ViewHelper

    attr_reader :course

    delegate :salaried?,
             :excluded_from_bursary?,
             :bursary_only?,
             :has_scholarship_and_bursary?,
             :has_fees?,
             :financial_support, to: :course

    def initialize(course)
      @course = course
    end
  end
end
