require "rails_helper"

feature "Search results", type: :feature do
  let(:results_page) { PageObjects::Page::Results.new }

  let(:base_parameters) { results_page_parameters }

  let(:subject) do
    build(
      :subject,
      :english,
      scholarship: "2000",
      bursary_amount: "4000",
      early_career_payments: "1000",
    )
  end

  let(:accrediting_provider) { build(:provider) }
  let(:decorated_course) { course.decorate }
  let(:courses) { [course] }

  let(:page_index) { nil }

  let(:stub_courses_request) do
    url = "http://localhost:3001/api/v3/recruitment_cycles/2020/courses"
    stub_request(:get, url)
      .with(query: base_parameters)
      .to_return(
        body: File.new("spec/fixtures/api_responses/ten_courses.json"),
        headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
      )
  end

  before do
    stub_subjects_request
    stub_courses_request

    visit results_path(page: page_index)
  end

  it "requests the courses" do
    expect(stub_courses_request).to have_been_requested
  end

  context "multiple courses" do
    it "Lists all courses" do
      expect(results_page.courses.count).to eq(10)

      results_page.courses.first.then do |first_course|
        expect(first_course.name.text).to eq("Geography (385N)")
        expect(first_course.provider_name.text).to eq("BHSSA")
        expect(first_course.description.text).to eq("PGCE with QTS full time")
        expect(first_course.accrediting_provider.text).to eq("University of Brighton")
        expect(first_course.funding_options.text).to eq("Student finance if you’re eligible")
        expect(first_course.main_address.text).to eq("Hove Park School, Hangleton Way, Hove, East Sussex, BN3 8AA")
        expect(first_course).not_to have_show_vacanices
      end
    end
  end

  context "with a second page" do
    before do
      base_parameters.merge(page_index: 2)
    end

    it "requests the second page" do
      expect(stub_courses_request).to have_been_requested
    end
  end
end
