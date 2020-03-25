class ResultsController < ApplicationController
  def index
    @results_view = ResultsView.new(query_parameters: request.query_parameters)

    # if filtering_by_blank_provider?
    #   params_hash = request.query_parameters.merge(l: 2)
    #   params_hash.delete("query")

    #   redirect_to results_path(params_hash)
    # end
  end

private

  def filtering_by_blank_provider?
    @results_view.provider_filter? && @results_view.provider.blank?
  end
end
