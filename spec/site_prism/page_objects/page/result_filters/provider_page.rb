module PageObjects
  module Page
    module ResultFilters
      class ProviderPage < SitePrism::Page
        set_url '/results/filter/provider{?query*}'

        class ProviderSuggestion < SitePrism::Section
          element :hyperlink, '[data-qa="provider_suggestion__link"]'
        end

        element :heading, '[data-qa="heading"]'
        element :back_link, '[data-qa="page-back"]'
        element :error, '[data-qa="error"]'

        element :search_expand, 'details'
        element :search_input, 'details .govuk-input'
        element :search_submit, 'details .govuk-button'

        sections :provider_suggestions, ProviderSuggestion, '[data-qa="provider_suggestion"]'
      end
    end
  end
end
