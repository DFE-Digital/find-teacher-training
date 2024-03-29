module PageObjects
  module Page
    module Search
      class SubjectPage < SitePrism::Page
        set_url '/results/filter/subject{?query*}'

        class SubjectAreaSection < SitePrism::Section
          class Subject < SitePrism::Section
            element :name, '[data-qa="subject__name"]'
            element :info, '[data-qa="subject__info"]'
            element :ske_course, '[data-qa="subject__ske_course"]'
            element :checkbox, '[data-qa="subject__checkbox"]'
          end

          element :legend, '[data-qa="subject_area__legend"]'
          element :name, '.govuk-accordion__section-heading'
          element :accordion_button, '.govuk-accordion__section-button'
          sections :subjects, Subject, '[data-qa="subject"]'
        end

        element :heading, '[data-qa="heading"]'
        element :back_link, '[data-qa="page-back"]'
        element :error, '[data-qa="error"]'

        sections :subject_areas, SubjectAreaSection, '[data-qa="subject_area"]'
        section :send_area, SubjectAreaSection, '[data-qa="send_area"]'
        element :find_courses, '.govuk-button'
      end
    end
  end
end
