require "rails_helper"

RSpec.describe "/results", type: :request do
  before do
    allow(Settings).to receive(:redirect_results_to_c_sharp).and_return(true)
  end

  it "redirects to c sharp version" do
    get "/results"
    expect(response).to redirect_to(Settings.search_and_compare_ui.base_url + "/results")
  end

  it "forwards querystring params" do
    get "/results?test=one&test_two=%26booyah"
    expect(response).to redirect_to(Settings.search_and_compare_ui.base_url + "/results?test=one&test_two=%26booyah")
  end

  it "decodes querystring commas" do
    get "/results?test=one&test_two=booyah%2Ckasha"
    expect(response).to redirect_to(Settings.search_and_compare_ui.base_url + "/results?test=one&test_two=booyah,kasha")
  end
end
