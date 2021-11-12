class FeatureFlagsController < ApplicationController
  include HttpAuthConcern

  def index; end

  def update
    FeatureFlag.send(action, feature_name)

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
