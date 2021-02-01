require 'rails_helper'

RSpec.describe '/cycle-ending-soon', type: :request do
  context 'within cycle' do
    it "redirects from '/cycle-ending-soon' to '/'" do
      get '/cycle-ending-soon'

      expect(response).to redirect_to('/')
    end
  end

  context 'cycle ending soon' do
    before do
      activate_feature(:cycle_ending_soon)
      deactivate_feature(:cycle_has_ended)
      Rails.application.reload_routes!
    end

    after do
      deactivate_feature(:cycle_ending_soon)
      Rails.application.reload_routes!
    end

    it "redirects from '/' to the '/cycle-ending-soon'" do
      get '/'

      expect(response).to redirect_to('/cycle-ending-soon')
    end
  end
end
