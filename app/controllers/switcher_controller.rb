class SwitcherController < ApplicationController
  skip_before_action :redirect_to_cycle_has_ended_if_find_is_down
  before_action :redirect_to_homepage_if_in_production

  def cycles; end

  def update
    new_cycle = params[:change_cycle_form][:cycle_schedule_name]
    SiteSetting.set(name: 'cycle_schedule', value: new_cycle)
    flash[:success] = I18n.t('cycles.updated')
    redirect_to cycles_path
  end

private

  def redirect_to_homepage_if_in_production
    redirect_to root_path if Rails.env.production?
  end
end
