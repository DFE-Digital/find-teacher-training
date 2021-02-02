require 'rails_helper'

describe '/start', type: :request do
  context 'within cycle' do
    it "redirects from '/start/location' to '/'" do
      get '/start/location'

      expect(response).to redirect_to('/')
    end
  end

  context 'nearing end of cycle' do
    before do
      activate_feature(:cycle_ending_soon)
      deactivate_feature(:cycle_has_ended)
      Rails.application.reload_routes!
    end

    after do
      deactivate_feature(:cycle_ending_soon)
      Rails.application.reload_routes!
    end

    it "navigates to '/start/location'" do
      get '/start/location'

      expect(response.status).to eq(200)
    end
  end
end
