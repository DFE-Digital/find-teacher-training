require 'rails_helper'

RSpec.describe 'Require basic authentication', type: :request do
  it 'requests when basic auth is disabled are let through' do
    FeatureFlag.deactivate('basic_auth_enabled')

    get feature_flags_path

    expect(response).to have_http_status(:ok)
  end

  it 'requests without basic auth get 401' do
    FeatureFlag.activate('basic_auth_enabled')

    get feature_flags_path

    expect(response).to have_http_status(:unauthorized)
  end

  it 'requests with invalid basic auth get 401' do
    FeatureFlag.activate('basic_auth_enabled')

    get feature_flags_path, headers: basic_auth_headers('wrong', 'auth')

    expect(response).to have_http_status(:unauthorized)
  end

  it 'requests with valid basic auth get 200' do
    FeatureFlag.activate('basic_auth_enabled')

    get feature_flags_path, headers: basic_auth_headers('foo', 'bar')

    expect(response).to have_http_status(:ok)
  end

  def basic_auth_headers(user, password)
    { 'HTTP_AUTHORIZATION' => \
           ActionController::HttpAuthentication::Basic.encode_credentials(user, password) }
  end
end
