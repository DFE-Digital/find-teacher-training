module HttpAuthConcern
  extend ActiveSupport::Concern

  included do
    before_action :http_authenticate
  end

  def http_authenticate
    return true unless FeatureFlag.activated?(:basic_auth_enabled)

    authenticate_or_request_with_http_basic do |username, password|
      username == Settings.basic_auth_username && password == Settings.basic_auth_password
    end
  end
end
