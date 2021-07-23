require 'rails_helper'

describe '/start', type: :request do
  context 'within cycle' do
    it "redirects from '/start/location' to '/'" do
      get '/start/location'

      expect(response).to redirect_to('/')
    end
  end

  context 'nearing end of cycle' do
    after do
      Rails.application.reload_routes!
    end

    it "navigates to '/start/location'" do
      Timecop.travel(CycleTimetable.apply_2_deadline + 1.hour) do
        Rails.application.reload_routes!

        get '/start/location'

        expect(response.status).to eq(200)
      end
    end
  end
end
