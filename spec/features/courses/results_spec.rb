require "rails_helper"

feature "Search results", type: :feature do
  def jsonapi_site_status(name, study_mode, status)
    build(:site_status, study_mode, site: build(:site, location_name: name), status: status)
  end

  before do
    allow(Settings).to receive(:redirect_results_to_c_sharp).and_return(false)
  end

  let(:provider) do
    build(:provider,
          provider_name: "ACME SCITT A0",
          provider_code: "T92",
          website: "https://scitt.org",
          address1: "1 Long Rd",
          postcode: "E1 ABC")
  end

  let(:provider2) do
    build(:provider,
          provider_name: "ACME SCITT A0",
          provider_code: "T92",
          website: "https://scitt.org",
          address1: "Building 64",
          address2: "32 Copton Lane",
          address3: "Bracknel",
          address4: "Berkshire",
          postcode: "NXT STP")
  end

  let(:course) do
    build(:course,
          name: "Primary",
          course_code: "X130",
          provider: provider,
          provider_code: provider.provider_code,
          recruitment_cycle: current_recruitment_cycle)
  end

  let(:current_recruitment_cycle) { build :recruitment_cycle }

  let(:results_page) { PageObjects::Page::Results.new }

  let(:subject) do
    build(:subject,
          :english,
          scholarship: "2000",
          bursary_amount: "4000",
          early_career_payments: "1000")
  end

  let(:accrediting_provider) { build(:provider) }
  let(:decorated_course) { course.decorate }
  let(:courses) { [course] }

  let(:courses_request) do
    fields = {
      courses: %i[provider_code course_code name description funding_type provider accrediting_provider subjects],
      providers: %i[provider_name address1 address2 address3 address4 postcode],
    }

    params = { recruitment_cycle_year: Settings.current_cycle }

    pagination = { page: page_index || 1, per_page: 10 }

    include = %i[provider accrediting_provider financial_incentive subjects]

    stub_api_v3_resource(
      type: Course,
      resources: courses,
      params: params,
      fields: fields,
      include: include,
      pagination: pagination,
      links: {
        last: api_v3_url(
          type: Course,
          params: params,
          fields: fields,
          include: include,
          pagination: pagination,
        ),
      },
    )
  end

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
    let(:course1) do
      build(:course,
            name: "First Course",
            course_code: "X130",
            provider: provider,
            provider_code: provider.provider_code,
            recruitment_cycle: current_recruitment_cycle,
            accrediting_provider: provider,
            description: "PGCE with QTS",
            funding_type: "salary")
    end

    let(:course2) do
      build(:course,
            name: "Second Course",
            course_code: "X255",
            provider: provider2,
            provider_code: provider.provider_code,
            recruitment_cycle: current_recruitment_cycle,
            description: "QTS",
            subjects: [subject])
    end
    let(:courses) { [course1, course2] }

    it "Lists all courses" do
      results_page.courses.first.then do |first_course|
        expect(first_course.name.text).to eq("#{courses.first.name} (#{courses.first.course_code})")
        expect(first_course.provider_name.text).to eq(courses.first.provider.provider_name)
        expect(first_course.description.text).to eq(courses.first.description)
        expect(first_course.accrediting_provider.text).to eq(courses.first.accrediting_provider.provider_name)
        expect(first_course.funding_options.text).to eq("Salary")
        expect(first_course.main_address.text).to eq("1 Long Rd, E1 ABC")
        expect(first_course).to have_selector("[href='#{course_path(provider_code: course1.provider_code, course_code: course1.course_code)}']")
      end

      results_page.courses.second.then do |second_course|
        expect(second_course.name.text).to eq("#{courses.second.name} (#{courses.second.course_code})")
        expect(second_course.provider_name.text).to eq(courses.second.provider.provider_name)
        expect(second_course.description.text).to eq(courses.second.description)
        expect(second_course.funding_options.text).to eq("Scholarship, bursary or student finance if you’re eligible")
        expect(second_course).not_to have_accrediting_provider
        expect(second_course.main_address.text).to eq("Building 64, 32 Copton Lane, Bracknel, Berkshire, NXT STP")
        expect(second_course).to have_selector("[href='#{course_path(provider_code: course2.provider_code, course_code: course2.course_code)}']")
      end
    end
  end

  context "with a second page" do
    let(:page_index) { 2 }

    it "requests the second page" do
      expect(courses_request).to have_been_requested
    end
  end
end
