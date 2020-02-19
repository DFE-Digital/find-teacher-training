require "rails_helper"

feature "Search results", type: :feature do
  let(:results_page) { PageObjects::Page::Results.new }
  let(:base_parameters) {
    { "filter[vacancies]" => "true",
      "filter[qualifications]" => "QtsOnly,PgdePgceWithQts,Other",
      "include" => "provider",
      "page[page]" => 1,
      "page[per_page]" => 10 }
  }

  let(:courses_request) {
    url = "http://localhost:3001/api/v3/recruitment_cycles/2020/courses"
    stub_request(:get, url)
      .with(query: base_parameters)
      .to_return(
        body: File.new("spec/fixtures/api_responses/courses.json"),
        headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
    )
  }

  let(:subject_request) do
    stub_api_v3_resource(
      type: SubjectArea,
      resources: nil,
      include: [:subjects],
    )
  end

  let(:page_index) { nil }

  before do
    subject_request

    courses_request

    visit results_path(page: page_index)
  end

  it "Requests the courses" do
    expect(courses_request).to have_been_requested
  end

  context "multiple courses" do
    it "Lists all courses" do
      results_page.courses.first.then do |first_course|
        expect(first_course.name.text).to eq("Mathematics (2VMB)")
        expect(first_course.provider_name.text).to eq("South East Learning Alliance")
        expect(first_course.description.text).to eq("QTS full time with salary")
        expect(first_course).not_to have_accrediting_provider
        expect(first_course.funding_options.text).to eq("Salary")
        expect(first_course.main_address.text).to eq("South East Learning Alliance, Riddlesdown Collegiate, Purley, South Croydon, Surrey, CR8 1EX")
      end

      results_page.courses.second.then do |second_course|
        expect(second_course.name.text).to eq("English (26Q6)")
        expect(second_course.provider_name.text).to eq("Delta Teaching School Alliance")
        expect(second_course.description.text).to eq("PGCE with QTS full time with salary")
        expect(second_course.funding_options.text).to eq("Salary")
        expect(second_course).not_to have_accrediting_provider
        expect(second_course.main_address.text).to eq("Education House, Spawd Bone Lane, Knottingley, West Yorkshire, WF11 0EP")
      end
    end
  end

  context "with a second page" do
    before do
      base_parameters.merge(page_index: 2)
    end

    it "requests the second page" do
      expect(courses_request).to have_been_requested
    end
  end
end
