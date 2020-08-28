require "rails_helper"

describe "/results", type: :request do
  context "a valid request" do
    before do
      default_url = "http://localhost:3001/api/v3/recruitment_cycles/2020/courses"

      stub_request(
        :get,
        "http://localhost:3001/api/v3/subjects?fields%5Bsubjects%5D=subject_name,subject_code&sort=subject_name",
      ).to_return(
        body: File.new("spec/fixtures/api_responses/subjects_sorted_name_code.json"),
        headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
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

  context "API returns client error (400)" do
    before do
      default_url = "http://localhost:3001/api/v3/recruitment_cycles/2020/courses"

      stub_request(
        :get,
        "http://localhost:3001/api/v3/subjects?fields%5Bsubjects%5D=subject_name,subject_code&sort=subject_name",
      ).to_return(
        body: File.new("spec/fixtures/api_responses/subjects_sorted_name_code.json"),
        headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
      )

      stub_request(:get, default_url)
        .with(query: results_page_parameters)
        .to_return(status: 400)
    end

    it "returns unprocessable entity (422)" do
      get "/results"
      expect(response).to have_http_status(422)
    end
  end
end
