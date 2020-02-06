module ResultFilters
  class LocationController < ApplicationController
    include FilterParameters

    before_action :build_results_filter_query_parameters

    def new; end

    def create
      if(!params[:l])
        flash[:error] = "Please choose an option"
        redirect_to location_path(params_without_unsupported_location_params)
      elsif params[:l] == "3"
        redirect_to provider_path(params_for_provider_search)
      else
        redirect_to results_path(params_without_unsupported_location_params)
      end
    end

  private

    def build_results_filter_query_parameters
      @results_filter_query_parameters = ResultsView.new(query_parameters: request.query_parameters)
        .query_parameters_with_defaults
    end

    def params_for_provider_search
      filter_params.except(:lat, :lng, :rad, :loc, :lq)
    end

    def params_without_unsupported_location_params
      filter_params.except(:lat, :lng, :rad, :query, :loc, :lq)
    end
  end
end
