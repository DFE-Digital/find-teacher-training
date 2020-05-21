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

  def apply
    course = Course
      .includes(:provider)
      .where(recruitment_cycle_year: Settings.current_cycle)
      .where(provider_code: params[:provider_code])
      .find(params[:course_code])
      .first

    Rails.logger.info("Course apply conversion. Provider: #{course.provider.provider_code}. Course: #{course.course_code}")

    # If course provider is University of Bolton and Maths or Computing
    if course.provider.provider_code == "8N5" && (course.course_code == "V595" || course.course_code == "Y710")
      case course.course_code
      when "V595"
        redirect_to "https://evision.bolton.ac.uk/urd/sits.urd/run/siw_ipp_lgn.login?process=siw_ipp_app&code1=1101-D&code2=0001"
      when "Y710"
        redirect_to "https://evision.bolton.ac.uk/urd/sits.urd/run/siw_ipp_lgn.login?process=siw_ipp_app&code1=1100-D&code2=0001"
      end
    else
      redirect_to "https://www.apply-for-teacher-training.education.gov.uk/candidate/apply?providerCode=#{course.provider.provider_code}&courseCode=#{course.course_code}"
    end
  end
end
