module Search
  class SecondarySubjectSelectionComponent < ViewComponent::Base
    attr_reader :form

    def initialize(form)
      @form = form
    end

    def render?
      form.object.age_group == 'secondary'
    end

    def secondary_subjects
      form.object.secondary_subjects.map do |subject|
        financial_info = nil

        if FeatureFlag.active?(:bursaries_and_scholarships_announced)
          if subject.decorate.has_scholarship_and_bursary?
            financial_info = "Scholarships of £#{number_with_delimiter(subject.scholarship, delimiter: ',')} and bursaries of £#{number_with_delimiter(subject.bursary_amount, delimiter: ',')} are available"
          elsif subject.decorate.has_scholarship?
            financial_info = "Scholarships of £#{number_with_delimiter(subject.scholarship, delimiter: ',')} are available"
          elsif subject.decorate.has_bursary?
            financial_info = "Bursaries of £#{number_with_delimiter(subject.bursary_amount, delimiter: ',')} available"
          end
        end

        Struct.new(:code, :name, :financial_info).new(subject.subject_code, subject.subject_name, financial_info)
      end
    end
  end
end
