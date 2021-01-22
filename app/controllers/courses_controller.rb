class CoursesController < ApplicationController
  decorates_assigned :course

  before_action :render_feedback_component, only: :show

  def show
    @course = Course
      .includes(:subjects)
      .includes(:provider)
      .includes(:accredited_body)
      .where(recruitment_cycle_year: Settings.current_cycle)
      .where(provider_code: params[:provider_code])
      .find(params[:course_code])
      .first

    @locations = Location
      .includes(:location_status)
      .where(recruitment_cycle_year: Settings.current_cycle, course_code: @course.code, provider_code: @course.provider.code)
      .all
      .select { |location| location.location_status.new_or_running? }
      .sort_by(&:name)
  rescue JsonApiClient::Errors::NotFound
    render template: 'errors/not_found', status: :not_found, formats: [:html]
  end

  def apply
    course = Course
      .includes(:provider)
      .where(recruitment_cycle_year: Settings.current_cycle)
      .where(provider_code: params[:provider_code])
      .find(params[:course_code])
      .first

    Rails.logger.info("Course apply conversion. Provider: #{course.provider.code}. Course: #{course.code}")

    redirect_to "https://www.apply-for-teacher-training.service.gov.uk/candidate/apply?providerCode=#{course.provider.code}&courseCode=#{course.code}"
  rescue JsonApiClient::Errors::NotFound
    render template: 'errors/not_found', status: :not_found, formats: [:html]
  end
end
