require 'rails_helper'

RSpec.describe '/cycle-ending-soon', type: :request do
  context 'within cycle' do
    it "redirects from '/cycle-ending-soon' to '/'" do
      get '/cycle-ending-soon'

      expect(response).to redirect_to('/')
    end
  end

  context 'cycle ending soon' do
    it "redirects from '/' to the '/cycle-ending-soon'" do
      Timecop.travel(CycleTimetable.apply_2_deadline + 1.hour) do
        Rails.application.reload_routes!
        get '/'

        expect(response).to redirect_to('/cycle-ending-soon')
      end
    end
  end
end
