module Courses
  module FinancialSupport
    class ScholarshipAndBursaryComponent < ViewComponent::Base
      include ViewHelper

      attr_reader :course

      delegate :scholarship_amount,
               :bursary_amount,
               :has_early_career_payments?,
               :subject_name, to: :course

      def initialize(course)
        @course = course
      end
    end
  end
end
