module PageObjects
  module Page
    module ResultPageFilters
      class StudyType < SitePrism::Page
        set_url '/results/filter/studytype{?query*}'

        element :back_link, '[data-qa="page-back"]'
        element :error, '[data-qa="error"]'
        element :heading, '[data-qa="heading"]'
        element :full_time, '[data-qa="full_time"]'
        element :part_time, '[data-qa="part_time"]'
        element :find_courses, '[data-qa="find-courses"]'
      end
    end
  end
end
