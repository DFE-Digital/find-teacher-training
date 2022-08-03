class ResultsController < ApplicationController
  before_action :render_feedback_component

  def index
    service = DeprecatedParametersService.new(parameters: request.query_parameters)
    if service.deprecated?
      return redirect_to results_path(service.parameters)
    end

    @results_view = ResultsView.new(query_parameters: request.query_parameters)
    @filters_view = ResultFilters::FiltersView.new(params:)

    begin
      @courses = @results_view.courses.all
      @number_of_courses_string = @results_view.number_of_courses_string
      render :index
    rescue JsonApiClient::Errors::ClientError
      render template: 'errors/unprocessable_entity', status: :unprocessable_entity
    end
  end
end
