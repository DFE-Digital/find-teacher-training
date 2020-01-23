module ResultFilters
  class LocationController < ApplicationController
    include FilterParameters

    def new; end

    def create
      params_without_unsupported_location_params = filter_params.except(:lat, :lng, :rad, :query, :loc, :lq)

      redirect_to results_path(params_without_unsupported_location_params)
    end
  end
end
