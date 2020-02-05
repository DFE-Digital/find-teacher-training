module PageObjects
  module Page
    module ResultFilters
      class ProviderPage < SitePrism::Page
        set_url "/results/filter/provider{?query*}"

        class ProviderSuggestion < SitePrism::Section
          element :hyperlink, '[data-qa="provider_suggestion__link"]'
        end

        element :back_link, '[data-qa="page-back"]'
        element :error, '[data-qa="error"]'

        section :search, '[data-qa="search"]' do
          element :input, '[data-qa="search__input"]'
          element :expand, '[data-qa="search__expand"]'
          element :submit, '[data-qa="search__submit"]'
        end
        sections :provider_suggestions, ProviderSuggestion, '[data-qa="provider_suggestion"]'
      end
    end
  end
end
