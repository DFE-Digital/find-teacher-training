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

  before do
    stub_results_page_request

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
end
