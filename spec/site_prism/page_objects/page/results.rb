module PageObjects
  module Page
    class CourseSection < SitePrism::Section
      element :provider_name, '[data-qa="course__provider_name"]'
      element :description, '[data-qa="course__description"]'
      element :name, '[data-qa="course__name"]'
      element :accrediting_provider, '[data-qa="course__accrediting_provider"]'
      element :funding_options, '[data-qa="course__funding_options"]'
      element :main_address, '[data-qa="course__main_address"]'
    end

    class Results < SitePrism::Page
      set_url "/results{?query*}"

      sections :courses, CourseSection, '[data-qa="course"]'

      element :next_button, '[data-qa="next_button"]'
      element :previous_button, '[data-qa="previous_button"]'
    end
  end
end
