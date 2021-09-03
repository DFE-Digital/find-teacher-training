class SitemapsController < ApplicationController
  def show
    @courses = Course
      .where(recruitment_cycle_year: SiteSetting.recruitment_cycle_year)
      .select('course_code', 'provider_code', 'changed_at')
      .page(1)
      .per(20_000)
      .all

    expires_in(1.day, public: true)
  end
end
