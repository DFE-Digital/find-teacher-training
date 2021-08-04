class SwitcherController < ApplicationController
  before_action redirect_to root_path if Rails.env.production?

  def cycles; end

  def update
    new_cycle = params[:change_cycle_form][:cycle_schedule_name]
    SiteSetting.set(name: 'cycle_schedule', value: new_cycle)
    Rails.application.reload_routes!

    flash[:success] = 'Cycle schedule updated'
    redirect_to cycles_path
  end
end
