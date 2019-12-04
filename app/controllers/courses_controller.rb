require 'byebug'
class CoursesController < ApplicationController
  def show
    @course = Course
      .where(recruitment_cycle_year: Settings.current_cycle)
      .where(provider_code: params[:provider_code])
      .find(params[:course_code])
      .first
  end
end
