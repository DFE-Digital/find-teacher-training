module ResultFilters
  class LocationController < ApplicationController
    include FilterParameters

    before_action :build_results_filter_query_parameters

    def new; end

    def start
      flash[:start_wizard] = true
    end

    def create
      # if searching for specific provider go to results page
      if provider_option_selected?
        redirect_to(provider_path(params_for_provider_search))
        return
      end

      form_params = strip(filter_params.clone).merge(sortby: ResultsView::DISTANCE)
      form_object = LocationFilterForm.new(form_params)
      if form_object.valid?
        all_params = form_params.merge!(form_object.params)

        if location_option_selected?
          submitted_params = params_for_location_search(all_params)
        elsif across_england_option_selected?
          submitted_params = params_for_across_england_search(all_params)
        end

        redirect_to(next_step(submitted_params))
      else
        flash[:error] = form_object.errors
        back_to_current_page_if_error(form_params)
      end
    end

  private

    def build_results_filter_query_parameters
      @results_filter_query_parameters = ResultsView.new(query_parameters: request.query_parameters)
        .query_parameters_with_defaults
    end

    def location_option_selected?
      filter_params[:l] == "1"
    end

    def across_england_option_selected?
      filter_params[:l] == "2"
    end

    def provider_option_selected?
      filter_params[:l] == "3"
    end

    def params_for_location_search(params)
      params.except(:query)
    end

    def params_for_across_england_search(params)
      params.except(:lat, :lng, :rad, :loc, :lq, :query, :sortby)
    end

    def params_for_provider_search
      filter_params.except(:lat, :lng, :rad, :loc, :lq)
    end

    def strip(params)
      params.reject { |_, v| v == "" }
    end

    def next_step(submitted_params)
      if flash[:start_wizard]
        start_subject_path(submitted_params)
      else
        results_path(submitted_params)
      end
    end

    def back_to_current_page_if_error(form_params)
      if flash[:start_wizard]
        redirect_to root_path(form_params)
      else
        redirect_to location_path(form_params)
      end
    end
  end
end
