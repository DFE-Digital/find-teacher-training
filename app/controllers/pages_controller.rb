# frozen_string_literal: true

class PagesController < ApplicationController
  skip_before_action :redirect_to_cycle_has_ended_if_find_is_down, only: :cycle_has_ended
  skip_before_action :redirect_to_maintenance_page_if_flag_is_active, only: :maintainance
  before_action :redirect_to_homepage_if_find_is_open, only: :cycle_has_ended
  before_action :redirect_to_homepage_unless_in_maintenance_mode, only: :maintainance

  def terms; end

  def privacy; end

  def accessibilty; end

  def cycle_has_ended; end

  def maintainance; end

private

  def redirect_to_homepage_if_find_is_open
    redirect_to root_path unless CycleTimetable.find_down?
  end

  def redirect_to_homepage_unless_in_maintenance_mode
    redirect_to root_path unless FeatureFlag.active?(:maintenance_mode)
  end
end
