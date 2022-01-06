module Courses
  class InternationalStudentsComponent < ViewComponent::Base
    include ViewHelper

    TRAIN_TO_TEACH_URL = 'https://www.gov.uk/government/publications/train-to-teach-in-england-non-uk-applicants/train-to-teach-in-england-non-uk-applicants#visas-and-immigration'.freeze
    APPLY_FOR_STUDENT_VISA_URL = 'https://www.gov.uk/government/publications/train-to-teach-in-england-non-uk-applicants/train-to-teach-in-england-if-youre-a-non-uk-citizen#visa'.freeze
    VISA_GUIDANCE_URL = 'https://www.gov.uk/government/publications/train-to-teach-in-england-non-uk-applicants/train-to-teach-in-england-if-youre-a-non-uk-citizen#visa'.freeze

    def initialize(course:)
      @course = course
    end

    def provider
      @provider ||= @course.provider
    end

    def visa_sponsorship_status
      
      if !@course.salaried? && provider.can_sponsor_student_visa
        
        "<p class=\"govuk-body\">You’ll need a visa or other immigration status that allows you to study in the UK. You already have this if you:</p>
        <ul class=\"govuk-list govuk-list--bullet\">
          <li>are an Irish citizen</li>
          <li>have settled or pre-settled status under the EU Settlement Scheme</li>
        </ul>
        
        <p class=\"govuk-body\">You may need to #{govuk_link_to('apply for a Student visa', APPLY_FOR_STUDENT_VISA_URL)}.</p>

        <p class=\"govuk-body\">To be able to apply for Student visa, you need a confirmed offer on a course.</p>
        
        <p class=\"govuk-body\">To get a confirmed offer, you need to pass criminal record and health checks.</p>
        
        <p class=\"govuk-body\">Visa sponsorship is available for this course. If you get a place on this course, we’ll help you apply for a Student visa.</p>
        
        <p class=\"govuk-body\">Alternatively, you may be #{govuk_link_to('eligible for a different type of visa', VISA_GUIDANCE_URL)} that allows you to train to be a teacher without being sponsored.</p>".html_safe                
        
      elsif @course.salaried? && provider.can_sponsor_skilled_worker_visa
        "We can sponsor #{govuk_link_to('Skilled Worker visas', TRAIN_TO_TEACH_URL)}, but this is not guaranteed.".html_safe
      else
        "We cannot sponsor visas. You’ll need to #{govuk_link_to('get the right visa or status to study in the UK', TRAIN_TO_TEACH_URL)}.".html_safe
      end
    end
  end
end
