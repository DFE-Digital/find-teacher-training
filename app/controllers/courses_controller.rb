class CoursesController < ApplicationController
  decorates_assigned :course

  before_action :render_feedback_component, only: :show

  def show
    @course = Rails.cache.fetch(course_cache_key, expires_in: 15.minutes) do
      Course
      .includes(:subjects)
      .includes(site_statuses: [:site])
      .includes(provider: [:sites])
      .includes(:accrediting_provider)
      .where(recruitment_cycle_year: Settings.current_cycle)
      .where(provider_code: params[:provider_code])
      .find(params[:course_code])
      .first
    end
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

    Rails.logger.info("Course apply conversion. Provider: #{course.provider.provider_code}. Course: #{course.course_code}")

    redirect_to "#{Settings.apply_base_url}/candidate/apply?providerCode=#{course.provider.provider_code}&courseCode=#{course.course_code}"
  rescue JsonApiClient::Errors::NotFound
    render template: 'errors/not_found', status: :not_found, formats: [:html]
  end

private

  def course_cache_key
    "ttapi-course-#{params[:course_code]}-#{params[:provider_code]}"
  end
end
