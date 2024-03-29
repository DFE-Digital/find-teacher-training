class FeatureFlagsController < ApplicationController
  include HttpAuthConcern

  skip_before_action :redirect_to_maintenance_page_if_flag_is_active

  def index; end

  def update
    FeatureFlag.send(action, feature_name)

    SlackNotificationJob.perform_now(
      ":flags: Feature ‘#{feature_name}‘ was #{action}d",
      feature_flags_path,
    )

    flash[:success] = "Feature ‘#{feature_name.humanize}’ #{action}d"
    redirect_to feature_flags_path
  end

private

  def action
    params[:state]
  end

  def feature_name
    params[:feature_name]
  end
end
