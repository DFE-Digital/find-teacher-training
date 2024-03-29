require 'rails_helper'

# The cookie expiry date is not accessible via capybara
# so we need to test cookies as a unit test via a controller spec
# rather than an integration test via a request spec
describe CookiePreferencesController do
  describe 'GET #new' do
    it 'returns http success' do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe '#create' do
    it 'sets cookie value' do
      post :create, params: { cookie_consent: 'true' }

      expect(response.cookies['consented-to-cookies']).to eq('true')
    end

    it 'sets cookie expiry' do
      stub_cookie_jar = ActiveSupport::HashWithIndifferentAccess.new
      allow(controller).to receive(:cookies).and_return(stub_cookie_jar)

      post :create, params: { cookie_consent: 'true' }
      cookie = stub_cookie_jar['consented-to-cookies']

      expect(cookie[:expires]).to be_within(1.second).of(6.months.from_now)
    end
  end
end
