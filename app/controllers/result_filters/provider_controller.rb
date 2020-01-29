module ResultFilters
  class ProviderController < ApplicationController
    include FilterParameters

    def new
      @provider_suggestions = Provider
        .select(:provider_code, :provider_name)
        .where(recruitment_cycle_year: "2020")
        .with_params(search: "ACME")
        .all
    end

    def create
      redirect_to results_path(filter_params)
    end
  end
end
