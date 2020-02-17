module PageObjects
  module Page
    module ResultFilters
      class SubjectPage < SitePrism::Page
        set_url "/results/filter/subject{?query*}"

        class SubjectAreaSection < SitePrism::Section
          class Subject < SitePrism::Section
            element :name, '[data-qa="subject__name"]'
            element :info, '[data-qa="subject__info"]'
            element :ske_course, '[data-qa="subject__ske_course"]'
            element :checkbox, '[data-qa="subject__checkbox"]'
          end

          element :legend, '[data-qa="subject_area__legend"]'
          element :name, '[data-qa="subject_area__name"]'
          element :accordion_button, '[data-qa="subject_area__accordion_button"]'
          sections :subjects, Subject, '[data-qa="subject"]'
        end

        element :back_link, '[data-qa="page-back"]'
        element :error, '[data-qa="error"]'

        sections :subject_areas, SubjectAreaSection, '[data-qa="subject_area"]'
        section :send_area, SubjectAreaSection, '[data-qa="send_area"]'
        element :continue, '[data-qa="continue"]'
      end
    end
  end
end
