require "rails_helper"

describe "/start/subject", type: :request do
  before do
    allow(Settings).to receive(:redirect_results_to_c_sharp).and_return(true)
    Rails.application.reload_routes!
  end

  it "redirects to c sharp version" do
    get "/start/subject"
    expect(response).to redirect_to(Settings.search_and_compare_ui.base_url + "/start/subject")
  end

  it "forwards querystring params" do
    get "/start/subject?test=one&test_two=%26booyah"
    expect(response).to redirect_to(Settings.search_and_compare_ui.base_url + "/start/subject?test=one&test_two=%26booyah")
  end

  it "decodes querystring commas" do
    get "/start/subject?test=one&test_two=booyah%2Ckasha"
    expect(response).to redirect_to(Settings.search_and_compare_ui.base_url + "/start/subject?test=one&test_two=booyah,kasha")
  end
end
