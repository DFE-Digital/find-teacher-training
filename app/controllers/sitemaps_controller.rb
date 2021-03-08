class SitemapsController < ApplicationController
  def show
    @courses = fetch_courses
  end

private

  def fetch_courses
    Rails.cache.fetch ['sitemap-api-request'], expires_in: 1.day do
      Course
        .where(recruitment_cycle_year: Settings.current_cycle)
        .select('course_code', 'provider_code', 'changed_at')
        .page(1)
        .per(20_000)
        .all
    end
  end
end
