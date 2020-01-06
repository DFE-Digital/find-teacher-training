require "rails_helper"

RSpec.describe "page requests", type: :request do
  describe "GET root_path" do
    it "redirects to curent search and compare ui app" do
      get root_path
      expect(response).to redirect_to(Settings.search_and_compare_ui.base_url)
    end
  end
end
