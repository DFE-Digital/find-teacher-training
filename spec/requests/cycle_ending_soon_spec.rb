require "rails_helper"

RSpec.describe "/cycle-ending-soon", type: :request do
  context "within cycle" do
    it "redirects from '/cycle-ending-soon' to '/'" do
      get "/cycle-ending-soon"

      expect(response).to redirect_to("/")
    end
  end

  context "cycle ending soon" do
    before do
      allow(Settings).to receive(:cycle_ending_soon).and_return(true)
      Rails.application.reload_routes!
    end

    after do
      allow(Settings).to receive(:cycle_ending_soon).and_return(false)
      Rails.application.reload_routes!
    end

    it "redirects from '/' to the '/cycle-ending-soon'" do
      get "/"

      expect(response).to redirect_to("/cycle-ending-soon")
    end
  end
end
