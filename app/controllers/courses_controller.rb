class CoursesController < ApplicationController
  decorates_assigned :course

  def show
    @course = Course
      .includes(:subjects)
      .includes(site_statuses: [:site])
      .includes(provider: [:sites])
      .includes(:accrediting_provider)
      .where(recruitment_cycle_year: Settings.current_cycle)
      .where(provider_code: params[:provider_code])
      .find(params[:course_code])
      .first
  rescue JsonApiClient::Errors::NotFound
    render file: "errors/not_found", status: :not_found
  end
end
