module PageObjects
  module Page
    module ResultFilters
      class Qualification < SitePrism::Page
        set_url "/results/filter/qualification{?query*}"

        element :heading, '[data-qa="heading"]'
        element :back_link, '[data-qa="page-back"]'
        element :error, '[data-qa="error"]'
        element :qts_only, '[data-qa="qts_only"]'
        element :pgde_pgce_with_qts, '[data-qa="pgde_pgce_with_qts"]'
        element :other, '[data-qa="other"]'
        element :find_courses, '[data-qa="find-courses"]'
      end
    end
  end
end
