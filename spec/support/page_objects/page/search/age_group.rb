module PageObjects
  module Page
    module Search
      class AgeGroup < SitePrism::Page
        set_url '/results/filter/age-groups{?query*}'

        element :secondary, '#search-age-groups-form-age-group-secondary-field'
      end
    end
  end
end
