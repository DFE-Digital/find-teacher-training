class ResultsController < ApplicationController
  def index
    service = DeprecatedParametersService.new(parameters: request.query_parameters)
    if service.deprecated?
      return redirect_to results_path(service.parameters)
    end

    @results_view = ResultsView.new(query_parameters: request.query_parameters)
  end
end
