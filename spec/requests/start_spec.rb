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
      allow(Settings).to receive(:cycle_ending_soon).and_return(true)
      Rails.application.reload_routes!
    end

    after do
      allow(Settings).to receive(:cycle_ending_soon).and_return(false)
      Rails.application.reload_routes!
    end

    it "navigates to '/start/location'" do
      get '/start/location'

      expect(response.status).to eq(200)
    end
  end
end
