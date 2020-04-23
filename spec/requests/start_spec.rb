require "rails_helper"

describe "/start", type: :request do
  context "when a suser requests /location" do
    it "redirects to root path" do
      get "/start/location"
      expect(response).to redirect_to("/")
    end
  end
end
