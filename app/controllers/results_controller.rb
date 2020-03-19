class ResultsController < ApplicationController
  def index
    parameter_converter = ConvertDeprecatedCsharpParametersService.new.call(parameters: request.query_parameters)
    if parameter_converter[:deprecated]
      return redirect_to results_path(parameter_converter[:parameters])
    end

    @results_view = ResultsView.new(query_parameters: request.query_parameters)
  end
end
