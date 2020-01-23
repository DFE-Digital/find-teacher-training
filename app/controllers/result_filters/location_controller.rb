module ResultFilters
  class LocationController < ApplicationController
    include FilterParameters

    def new; end

    def create
      if(!params[:l])
        flash[:error] = "Please choose an option"
        redirect_to location_path(params_without_unsupported_location_params)
      else
        redirect_to results_path(params_without_unsupported_location_params)
      end
    end

  private

    def params_without_unsupported_location_params
      filter_params.except(:lat, :lng, :rad, :query, :loc, :lq)
    end
  end
end
