module PageObjects
  module Page
    module ResultFilters
      class Location < SitePrism::Page
        set_url "/results/filter/location{?query*}"

        element :back_link, '[data-qa="page-back"]'
        element :error, '[data-qa="error"]'
        element :across_england, '[data-qa="across_england"]'
        element :by_provider, '[data-qa="by_provider"]'
        element :provider_search, '[data-qa="provider_search"]'
        element :find_courses, '[data-qa="find_courses"]'
      end
    end
  end
end
