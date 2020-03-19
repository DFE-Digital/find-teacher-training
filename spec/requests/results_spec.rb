require "rails_helper"

describe "/results", type: :request do
  before do
    default_url = "http://localhost:3001/api/v3/recruitment_cycles/2020/courses"

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

  it "returns success (200)" do
    get "/results"
    expect(response).to have_http_status(200)
  end
end
