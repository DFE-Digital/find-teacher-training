module PageObjects
  module Page
    module ResultFilters
      class ProviderPage < SitePrism::Page
        set_url "/results/filter/provider{?query*}"

        class ProviderSuggestion < SitePrism::Section
          element :submit, '[data-qa="provider_suggestion__submit"]'
        end

        element :back_link, '[data-qa="page-back"]'
        element :error, '[data-qa="error"]'

        sections :provider_suggestions, ProviderSuggestion, '[data-qa="provider_suggestion"]'
      end
    end
  end
end
