module PageObjects
  module Page
    module ResultFilters
      class StudyType < SitePrism::Page
        set_url "/results/filter/studytype{?query*}"

        element :error, '[data-qa="error"]'
        element :full_time, '[data-qa="full_time"]'
        element :part_time, '[data-qa="part_time"]'
        element :find_courses, '[data-qa="find_courses"]'
      end
    end
  end
end
