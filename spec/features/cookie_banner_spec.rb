require "rails_helper"

feature "cookie banner", type: :feature do
  let(:results_page) { PageObjects::Page::Results.new }
  let(:params) {}
  let(:subject_areas) do
    [
        build(:subject_area, subjects: [
            build(:subject, :primary, id: 1),
            build(:subject, :biology, id: 10),
            build(:subject, :english, id: 21),
            build(:subject, :mathematics, id: 25),
            build(:subject, :french, id: 34),
        ]),
        build(:subject_area, :secondary),
    ]
  end
  let(:default_url) do
    "http://localhost:3001/api/v3/recruitment_cycles/2020/courses"
  end

  let(:base_parameters) do
    {
      "filter[vacancies]" => "true",
      "filter[qualifications]" => "QtsOnly,PgdePgceWithQts,Other",
      "include" => "provider",
      "page[page]" => 1,
      "page[per_page]" => 10,
    }
  end

  before do
    stub_request(:get, default_url)
      .with(query: base_parameters)
      .to_return(
        body: File.new("spec/fixtures/api_responses/courses.json"),
        headers: { "Content-Type": "application/vnd.api+json; charset=utf-8" },
      )

    stub_api_v3_resource(type: SubjectArea,
                          resources: subject_areas,
                          include: [:subjects])

    visit results_path(params)
  end

  it "displays a cookie banner" do
    expect(results_page).to have_cookie_banner
    expect(results_page.cookie_banner).to have_accept_all_cookies
    expect(results_page.cookie_banner).to have_set_preference_link
  end

  it "does not display on the cookies page" do
    visit cookie_preferences_path
    expect(page).not_to have_selector('[data-qa="cookie-banner"]')
  end
end
