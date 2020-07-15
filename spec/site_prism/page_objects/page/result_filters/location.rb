module PageObjects
  module Page
    module ResultFilters
      class Location < SitePrism::Page
        set_url "/results/filter/location{?query*}"

        element :back_link, '[data-qa="page-back"]'
        element :error, '[data-qa="error"]'
        element :error_text, '[data-qa="error__text"]'
        element :error_heading, '[data-qa="error__heading"]'
        element :across_england, '[data-qa="across-england"]'
        element :by_provider, '[data-qa="by-provider"]'
        element :by_provider_conditional, '[data-qa="by-provider-conditional"]'
        element :provider_error, '[data-qa="provider-error"]'
        element :provider_search, '[data-qa="provider-search"]'
        element :find_courses, '[data-qa="find-courses"]'
        element :location_conditional, '[data-qa="location-conditional"]'
        element :location_error, '[data-qa="location-error"]'
        element :by_postcode_town_or_city, '[data-qa="by_postcode_town_or_city"]'
        element :location_query, '[data-qa="location-query"]'
        element :unknown_location, 'input[value="Unknown location"]'
      end
    end
  end
end
