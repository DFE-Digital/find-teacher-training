class ResultsController < ApplicationController
  before_action :redirect_to_c_sharp

  def index
    @results_view = ResultsView.new(query_parameters: request.query_parameters)

    if filtering_by_blank_provider?
      params_hash = request.query_parameters.merge(l: 2)
      params_hash.delete("query")

      redirect_to results_path(params_hash)
    end
  end

private

  def filtering_by_blank_provider?
    @results_view.provider_filter? && @results_view.provider.blank?
  end

  def redirect_to_c_sharp
    return unless Settings.redirect_results_to_c_sharp

    query_string = request.query_string
    base_url = Settings.search_and_compare_ui.base_url

    redirect_uri = URI(base_url)
    redirect_uri.path = "/results"
    redirect_uri.query = query_string.gsub("%2C", ",") if query_string.present?

    redirect_to redirect_uri.to_s
  end

  def subjects_params_array
    params["subjects"].split(",")
  end
end
