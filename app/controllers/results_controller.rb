class ResultsController < ApplicationController
  def index
    @results_view = ResultsView.new(query_parameters: request.query_parameters)
  end
end
