module Search
  class PrimarySubjectSelectionComponent < ViewComponent::Base
    attr_reader :form

    def initialize(form)
      @form = form
    end

    def render?
      form.object.age_group == 'primary'
    end
  end
end
