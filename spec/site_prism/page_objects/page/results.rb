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

      element :location_link, '[data-qa="filters__location_link"]'
      element :subject_link, '[data-qa="filters__subject"]'
      element :study_type_link, '[data-qa="filters__study_type_link"]'
      element :qualification_link, '[data-qa="filters__qualification_link"]'
      element :salary_link, '[data-qa="filters__salary_link"]'
      element :vacancies_link, '[data-qa="filters__vacancies_link"]'
    end
  end
end
