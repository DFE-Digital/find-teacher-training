class ResultsController < ApplicationController
  include CsharpRailsSubjectConversionHelper
  before_action :redirect_to_c_sharp

  def index
    @results_view = ResultsView.new(query_parameters: request.query_parameters)

    @subjects =
      if params["subjects"].present?
        SubjectArea.includes(:subjects).all
          .map(&:subjects).flatten
          .select { |subject| rails_to_csharp_subject_id(id: subject.id).in?(subjects_params_array) }
          .sort_by(&:subject_name)[0..3]
      else
        SubjectArea.includes(:subjects).all
          .map(&:subjects).flatten
          .sort_by(&:subject_name)[0..3]
      end
  end

private

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
