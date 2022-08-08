require 'rails_helper'

# The cookie expiry date is not accessible via capybara
# so we need to test cookies as a unit test via a controller spec
# rather than an integration test via a request spec
describe CookiePreferencesController, type: :controller do
  describe 'GET #show' do
    it 'returns http success' do
      get :show
      expect(response).to have_http_status(:success)
    end
  end

  describe '#update' do
    it 'sets cookie value' do
      put :update, params: { cookie_preferences_form: { analytics_consent: 'true', marketing_consent: 'true' } }

      expect(response.cookies[Settings.cookies.analytics.name]).to eq('true')
      expect(response.cookies[Settings.cookies.marketing.name]).to eq('true')
    end

    it 'sets cookie expiry' do
      stub_cookie_jar = HashWithIndifferentAccess.new
      allow(controller).to receive(:cookies).and_return(stub_cookie_jar)

      put :update, params: { cookie_preferences_form: { analytics_consent: 'true', marketing_consent: 'true' } }
      cookie = stub_cookie_jar[Settings.cookies.analytics.name]

      expect(cookie[:expires]).to be_within(1.second).of(Settings.cookies.expire_after_days.days.from_now)
    end
  end
end
