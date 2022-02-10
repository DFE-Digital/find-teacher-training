module Courses
  class InternationalStudentsComponent < ViewComponent::Base
    include ViewHelper

    TRAIN_TO_TEACH_NON_UK_CITIZEN_URL = 'https://www.gov.uk/government/publications/train-to-teach-in-england-non-uk-applicants/train-to-teach-in-england-if-youre-a-non-uk-citizen'.freeze

    def initialize(course:)
      @course = course
    end

    def provider
      @provider ||= @course.provider
    end

    def visa_sponsorship_status
      if !@course.salaried? && provider.can_sponsor_student_visa
        "<p class=\"govuk-body\">You’ll need the right to study in the UK. You already have this if, for example, you:</p>
        <ul class=\"govuk-list govuk-list--bullet\">
          <li>are an Irish citizen</li>
          <li>have settled or pre-settled status under the EU Settlement Scheme</li>
        </ul>

        <p class=\"govuk-body\">If you do not already have the right to study in the UK for the duration of this course, you may need to apply for a Student visa.</p>

        <p class=\"govuk-body\">To do this, you’ll need to be sponsored by your training provider.</p>

        <p class=\"govuk-body\">Before you apply for this course, contact us to check Student visa sponsorship is available. If it is, and you get a place on this course, we’ll help you apply for your visa.</p>

        <p class=\"govuk-body\">Alternatively, check if you’re eligible for a different type of visa, such as a Graduate or Family visa, that allows you to train to be a teacher without being sponsored.</p>

        <p class=\"govuk-body\">Find out more about #{govuk_link_to('training to teach in England', TRAIN_TO_TEACH_NON_UK_CITIZEN_URL)}.</p>".html_safe
      elsif @course.salaried? && provider.can_sponsor_skilled_worker_visa
        "<p class=\"govuk-body\">You’ll need the right to work in the UK. You already have this if, for example, you:</p>
        <ul class=\"govuk-list govuk-list--bullet\">
          <li>are an Irish citizen</li>
          <li>have settled or pre-settled status under the EU Settlement Scheme</li>
        </ul>

        <p class=\"govuk-body\">If you do not already have the right to work in the UK for the duration of this course, you may need to apply for a Skilled Worker visa.</p>

        <p class=\"govuk-body\">To do this, you’ll need to be sponsored by your employer.</p>

        <p class=\"govuk-body\">Before you apply for this course, contact us to check Skilled Worker visa sponsorship is available. If it is, and you get a place on this course, we’ll help you apply for your visa.</p>

        <p class=\"govuk-body\">Alternatively, check if you’re eligible for a different type of visa, such as a Graduate or Family visa, that allows you to train to be a teacher without being sponsored.</p>

        <p class=\"govuk-body\">Find out more about #{govuk_link_to('training to teach in England', TRAIN_TO_TEACH_NON_UK_CITIZEN_URL)}.</p>".html_safe
      elsif @course.salaried?
        "<p class=\"govuk-body\">You’ll need the right to work in the UK. You already have this if, for example, you:</p>
        <ul class=\"govuk-list govuk-list--bullet\">
          <li>are an Irish citizen</li>
          <li>have settled or pre-settled status under the EU Settlement Scheme</li>
        </ul>

        <p class=\"govuk-body\">The main visa for salaried courses is the Skilled Worker visa.</p>

        <p class=\"govuk-body\">To apply for a Skilled Worker visa you need to be sponsored by your employer.</p>

        <p class=\"govuk-body\">Sponsorship is not available for this course.</p>

        <p class=\"govuk-body\">If you need a visa, filter your course search to find courses with visa sponsorship.</p>

        <p class=\"govuk-body\">Alternatively, check if you're eligible for a different type of visa, such as a Graduate or Family visa, that allows you to work in the UK without being sponsored.</p>

        <p class=\"govuk-body\">Find out more about #{govuk_link_to('training to teach in England', TRAIN_TO_TEACH_NON_UK_CITIZEN_URL)}.</p>".html_safe
      else
        "<p class=\"govuk-body\">You’ll need the right to study in the UK. You already have this if, for example, you:</p>
        <ul class=\"govuk-list govuk-list--bullet\">
          <li>are an Irish citizen</li>
          <li>have settled or pre-settled status under the EU Settlement Scheme</li>
        </ul>

        <p class=\"govuk-body\">The main visa for ‘fee-paying’ courses (courses that you have to pay for) is the Student visa.</p>

        <p class=\"govuk-body\">To apply for a Student visa you need to be sponsored by your training provider.</p>

        <p class=\"govuk-body\">Sponsorship is not available for this course.</p>

        <p class=\"govuk-body\">If you need a visa, filter your course search to find courses with visa sponsorship.</p>

        <p class=\"govuk-body\">Alternatively, check if you’re eligible for a different type of visa, such as a Graduate or Family visa, that allows you to study in the UK without being sponsored.</p>

        <p class=\"govuk-body\">Find out more about #{govuk_link_to('training to teach in England', TRAIN_TO_TEACH_NON_UK_CITIZEN_URL)}.</p>".html_safe
      end
    end
  end
end
