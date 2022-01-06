module Courses
  class InternationalStudentsComponent < ViewComponent::Base
    include ViewHelper

    TRAIN_TO_TEACH_URL = 'https://www.gov.uk/government/publications/train-to-teach-in-england-non-uk-applicants/train-to-teach-in-england-non-uk-applicants#visas-and-immigration'.freeze
    VISA_GUIDANCE_URL = 'https://www.gov.uk/government/publications/train-to-teach-in-england-non-uk-applicants/train-to-teach-in-england-if-youre-a-non-uk-citizen#visa'.freeze
    OTHER_VISA_GUIDANCE_URL = 'https://www.gov.uk/government/publications/train-to-teach-in-england-non-uk-applicants/train-to-teach-in-england-if-youre-a-non-uk-citizen#studying-and-working-as-a-teacher-in-the-uk-without-a-skilled-worker-visa-or-a-student-visa'.freeze
    
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
        
        <p class=\"govuk-body\">You may need to #{govuk_link_to('apply for a Student visa', VISA_GUIDANCE_URL)}.</p>

        <p class=\"govuk-body\">To be able to apply for Student visa, you need a confirmed offer on a course.</p>
        
        <p class=\"govuk-body\">To get a confirmed offer, you need to pass criminal record and health checks.</p>
        
        <p class=\"govuk-body\">Visa sponsorship is available for this course. If you get a place on this course, we’ll help you apply for a Student visa.</p>
        
        <p class=\"govuk-body\">Alternatively, you may be eligible for other visa types that allow you to #{govuk_link_to('train to be a teacher without a Student visa', OTHER_VISA_GUIDANCE_URL)}.</p>".html_safe
      elsif @course.salaried? && provider.can_sponsor_skilled_worker_visa
        "<p class=\"govuk-body\">You’ll need a visa or other immigration status that allows you to work in the UK. You already have this if you:</p>
        <ul class=\"govuk-list govuk-list--bullet\">
          <li>are an Irish citizen</li>
          <li>have settled or pre-settled status under the EU Settlement Scheme</li>
        </ul>
        
        <p class=\"govuk-body\">For courses that come with a salary, this often means #{govuk_link_to('applying for a Skilled Worker visa', VISA_GUIDANCE_URL)}.</p>
        
        <p class=\"govuk-body\">To be able to apply for a Skilled Worker visa, you need a confirmed offer on a salaried teacher training course. This needs to include employment at a school which has an employer sponsor licence.</p>
        
        <p class=\"govuk-body\">To get a confirmed offer, you need to pass criminal record and health checks.</p>
        
        <p class=\"govuk-body\">Get in touch to find out if we can help you organise a Skilled Worker visa.</p>
        
        <p class=\"govuk-body\">Alternatively, you may be eligible for other visa types that allow you to #{govuk_link_to('train to be a teacher without a Skilled Worker visa', OTHER_VISA_GUIDANCE_URL)}.</p>".html_safe
      elsif @course.salaried?
        "<p class=\"govuk-body\">You’ll need a visa or other immigration status that allows you to work in the UK. You already have this if you:</p>
        <ul class=\"govuk-list govuk-list--bullet\">
          <li>are an Irish citizen</li>
          <li>have settled or pre-settled status under the EU Settlement Scheme</li>
        </ul>
        
        <p class=\"govuk-body\">Skilled Worker visa sponsorship is not available for this course.</p>

        <p class=\"govuk-body\">If you do not already have the right to work in the UK, you can:</p>

        <ul class=\"govuk-list govuk-list--bullet\">
          <li>search for courses where visa sponsorship is available</li>
          <li>see if you’re eligible for other visa types that allow you to #{govuk_link_to('train to be a teacher without a Skilled Worker visa', OTHER_VISA_GUIDANCE_URL)}</li>
        </ul>
        ".html_safe        
      else        
        "<p class=\"govuk-body\">You’ll need a visa or other immigration status that allows you to study in the UK. You already have this if you:</p>
        <ul class=\"govuk-list govuk-list--bullet\">
          <li>are an Irish citizen</li>
          <li>have settled or pre-settled status under the EU Settlement Scheme</li>
        </ul>
        
        <p class=\"govuk-body\">Student visa sponsorship is not available for this course.</p>

        <p class=\"govuk-body\">If you do not already have the right to study in the UK, you can:</p>

        <ul class=\"govuk-list govuk-list--bullet\">
          <li>search for courses where visa sponsorship is available</li>
          <li>see if you’re eligible for other visa types that allow you to #{govuk_link_to('train to be a teacher without a Student visa', OTHER_VISA_GUIDANCE_URL)}</li>
        </ul>".html_safe
      end
    end
  end
end
