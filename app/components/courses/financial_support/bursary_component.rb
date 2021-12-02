module Courses
  module FinancialSupport
    class BursaryComponent < ViewComponent::Base
      attr_reader :course

      delegate :bursary_amount,
               :bursary_requirements,
               :bursary_first_line_ending, to: :course

      def initialize(course)
        @course = course
      end
    end
  end
end
