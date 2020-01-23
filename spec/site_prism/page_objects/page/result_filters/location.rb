module PageObjects
  module Page
    module ResultFilters
      class Location < SitePrism::Page
        set_url "/results/filter/location{?query*}"

        element :back_link, '[data-qa="page-back"]'
        element :error, '[data-qa="error"]'
        element :across_england, '[data-qa="across_england"]'
        element :find_courses, '[data-qa="find_courses"]'
      end
    end
  end
end
