class ResultsController < ApplicationController
  before_action :redirect_to_c_sharp

  def index
    @results_view = ResultsView.new(query_parameters: request.query_parameters)
    @courses = Course
      .includes(:provider)
      .includes(:accrediting_provider)
      .includes(:financial_incentive)
      .includes(:subjects)
      .where(recruitment_cycle_year: Settings.current_cycle)
      .where(provider_code: nil)
      .page(params[:page])
      .per(10)
      .select(courses: %i[
          provider_code
          course_code
          name
          description
          funding_type
          provider
          accrediting_provider
          subjects
        ], providers: %i[
          provider_name
          address1
          address2
          address3
          address4
          postcode
        ]).all
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
end
