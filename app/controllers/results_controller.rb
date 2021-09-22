class ResultsController < ApplicationController
  include CsharpRailsSubjectConversionHelper

  before_action :render_feedback_component, :convert_csharp_params_to_rails

  def index
    service = DeprecatedParametersService.new(parameters: request.query_parameters)
    if service.deprecated?
      return redirect_to results_path(service.parameters)
    end

    @results_view = ResultsView.new(query_parameters: request.query_parameters)
    @filters_view = ResultFilters::FiltersView.new(params: params)

    begin
      @courses = @results_view.courses.all
      @number_of_courses_string = @results_view.number_of_courses_string

      expires_in 10.minutes
    rescue JsonApiClient::Errors::ClientError
      render template: 'errors/unprocessable_entity', status: :unprocessable_entity
    end
  end

private

  def convert_csharp_params_to_rails
    if params['subject_codes'].blank? && convert_csharp_subject_id_params_to_subject_code.present?
      request.query_parameters['subject_codes'] = convert_csharp_subject_id_params_to_subject_code
    end
  end
end
