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

      def duplicate_requirement(requirement)
        bursary_first_line_ending.sub!(/[.:]$/, '') == requirement
      end
    end
  end
end
