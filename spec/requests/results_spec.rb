require "rails_helper"

describe "/results", type: :request do
  before do
    default_url = "http://localhost:3001/api/v3/recruitment_cycles/2020/courses"

    allow(Settings).to receive(:redirect_results_to_c_sharp).and_return(true)

    stub_api_v3_resource(
      type: SubjectArea,
      resources: nil,
      include: [:subjects],
    )

    stub_request(:get, default_url)
        .with(query: results_page_parameters)
        .to_return(
          body: File.new("spec/fixtures/api_responses/ten_courses.json"),
          headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
        )
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
