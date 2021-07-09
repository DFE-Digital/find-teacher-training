require 'rails_helper'

describe '/cycle-has-ended', type: :request do
  context 'within cycle' do
    it "redirects '/cycle-has-ended' to '/'" do
      get '/cycle-has-ended'

      expect(response).to redirect_to('/')
    end
  end

  context 'end of cycle' do
    before do
      Timecop.freeze(2021, 10, 3, 1)
      Rails.application.reload_routes!
    end

    after do
      Timecop.return
      Rails.application.reload_routes!
    end

    [
      '/',
      '/start/foo',
      '/results',
      '/course/foo',
    ].each do |path|
      it "redirects #{path} to '/cycle-has-ended'" do
        get path

        expect(response).to redirect_to('/cycle-has-ended')
      end
    end
  end
end
