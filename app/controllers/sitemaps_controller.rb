class SitemapsController < ApplicationController
  def show
    @courses = Course
      .includes(:provider)
      .where(recruitment_cycle_year: Settings.current_cycle)
      .all
  end
end
