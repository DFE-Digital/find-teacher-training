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

      def scholarship_body
        I18n.t("scholarships.#{subject_name.downcase}.body", default: nil)
      end

      def scholarship_url
        I18n.t("scholarships.#{subject_name.downcase}.url", default: nil)
      end
    end
  end
end
