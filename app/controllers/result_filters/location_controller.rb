module ResultFilters
  class LocationController < ApplicationController
    include FilterParameters
    include QuerySanitizer

    before_action :build_results_filter_query_parameters

    def new; end

    def start
      flash[:start_wizard] = true
    end

    def create
      sanitized_params = filter_params.
        clone.
        merge("query" => strip_non_ascii(provider_query), "lq" => strip_non_ascii(location_query))

      # if searching for specific provider go to results page
      if provider_option_selected?
        redirect_to(provider_path(get_params_for_selected_option(sanitized_params)))
        return
      end

      form_params = strip_empty(sanitized_params.clone).merge(sortby: ResultsView::DISTANCE)
      form_object = LocationFilterForm.new(form_params)
      if form_object.valid?
        all_params = form_params.merge!(form_object.params)
        redirect_to(next_step(all_params))
      else
        flash[:error] = form_object.errors
        back_to_current_page_if_error(form_params)
      end
    end

  private

    def location_query
      filter_params["lq"]
    end

    def provider_query
      filter_params["query"]
    end

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

    def get_params_for_selected_option(all_params)
      if location_option_selected?
        all_params.except(:query)
      elsif across_england_option_selected?
        all_params.except(:lat, :lng, :rad, :loc, :lq, :query, :sortby)
      elsif provider_option_selected?
        all_params.except(:lat, :lng, :rad, :loc, :lq)
      end
    end

    def strip_empty(params)
      params.reject { |_, v| v == "" }
    end

    def next_step(all_params)
      submitted_params = get_params_for_selected_option(all_params)
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
