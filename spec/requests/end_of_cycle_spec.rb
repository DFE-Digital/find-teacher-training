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
      '/start/subject?l=2',
      '/results',
      '/course/1N1/238T',
    ].each do |path|
      it "redirects #{path} to '/cycle-has-ended'" do
        get path

        expect(response).to redirect_to('/cycle-has-ended')
      end
    end
  end
end
