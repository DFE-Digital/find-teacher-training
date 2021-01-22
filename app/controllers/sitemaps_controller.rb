class SitemapsController < ApplicationController
  def show
    @courses = Course
      .includes(:provider)
      .where(recruitment_cycle_year: Settings.current_cycle)
      .select('code', 'changed_at')
      .page(1)
      .per(20_000)
      .all
  end
end
