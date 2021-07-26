module Courses
  class InternationalStudentsComponent < ViewComponent::Base
    include ViewHelper

    TRAIN_TO_TEACH_URL = 'https://www.gov.uk/government/publications/train-to-teach-in-england-non-uk-applicants/train-to-teach-in-england-non-uk-applicants#visas-and-immigration'.freeze

    def initialize(course:)
      @course = course
    end

    def provider
      @provider ||= @course.provider
    end

    def visa_sponsorship_status
      if !@course.salaried? && provider.can_sponsor_student_visa
        "We can sponsor #{govuk_link_to('Student visas', TRAIN_TO_TEACH_URL)}, but this is not guaranteed.".html_safe
      elsif @course.salaried? && provider.can_sponsor_skilled_worker_visa
        "We can sponsor #{govuk_link_to('Skilled Worker visas', TRAIN_TO_TEACH_URL)}, but this is not guaranteed.".html_safe
      else
        "We cannot sponsor visas. You will need to #{govuk_link_to('get the right visa or status to study in the UK', TRAIN_TO_TEACH_URL)}.".html_safe
      end
    end
  end
end
