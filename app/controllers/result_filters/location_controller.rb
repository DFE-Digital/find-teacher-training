module ResultFilters
  class LocationController < ApplicationController
    include FilterParameters

    before_action :build_results_filter_query_parameters

    def new; end

    def start; end

    def create
      if provider_option_selected?
        redirect_to(provider_path(params_for_provider_search)) && return
      elsif across_england_option_selected?
        redirect_to(results_path(params_for_across_england_search)) && return
      end

      form_params = strip(filter_params.clone)
      form_object = LocationFilterForm.new(form_params)
      if form_object.valid?
        all_params = form_params.merge!(form_object.params)
        redirect_to results_path(all_params)
      else
        flash[:error] = form_object.errors
        redirect_to location_path(form_params)
      end
    end

  private

    def build_results_filter_query_parameters
      @results_filter_query_parameters = ResultsView.new(query_parameters: request.query_parameters)
        .query_parameters_with_defaults
    end

    def across_england_option_selected?
      filter_params[:l] == "2"
    end

    def provider_option_selected?
      filter_params[:l] == "3"
    end

    def params_for_provider_search
      filter_params.except(:lat, :lng, :rad, :loc, :lq)
    end

    def params_for_across_england_search
      filter_params.except(:lat, :lng, :rad, :loc, :lq, :query)
    end

    def strip(params)
      params.reject { |_, v| v == "" }
    end
  end
end
