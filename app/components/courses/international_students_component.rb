module Courses
  class InternationalStudentsComponent < ViewComponent::Base
    include ViewHelper

    def initialize(provider:)
      @provider = provider
    end

    def visa_sponsorship_status
      if @provider.can_sponsor_all_visas?
        'can sponsor Student and Skilled Worker visas, but this is not guaranteed'
      elsif @provider.can_only_sponsor_student_visa?
        'can sponsor Student visas, but this is not guaranteed'
      elsif @provider.can_only_sponsor_skilled_worker_visa?
        'can sponsor Skilled Worker visas, but this is not guaranteed'
      else
        'cannot sponsor visas'
      end
    end
  end
end
