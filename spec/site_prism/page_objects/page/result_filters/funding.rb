module PageObjects
  module Page
    module ResultFilters
      class Funding < SitePrism::Page
        set_url '/results/filter/funding{?query*}'

        element :heading, '[data-qa="heading"]'
        element :back_link, '[data-qa="page-back"]'
        element :all_courses, '[data-qa="all_courses"]'
        element :salary_courses, '[data-qa="salary_courses"]'
        element :find_courses, '[data-qa="find-courses"]'
      end
    end
  end
end
