module PageObjects
  module Page
    module ResultFilters
      class Vacancy < SitePrism::Page
        set_url "/results/filter/vacancy{?query*}"

        element :heading, '[data-qa="heading"]'
        element :back_link, '[data-qa="page-back"]'
        element :error, '[data-qa="error"]'
        element :with_vacancies, '[data-qa="with_vacancies"]'
        element :with_and_without_vacancies, '[data-qa="with_and_without_vacancies"]'
        element :find_courses, '[data-qa="find-courses"]'
      end
    end
  end
end
