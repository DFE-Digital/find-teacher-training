require "rails_helper"

feature "Course show", type: :feature do
  let(:provider) do
    build(:provider,
          provider_name: "ACME SCITT A0",
          provider_code: "T92")
  end

  let(:course) do
    build(:course,
          name: "Primary",
          course_code: "X130",
          provider: provider,
          provider_code: provider.provider_code,
          recruitment_cycle: current_recruitment_cycle
    )
  end

  let(:current_recruitment_cycle) { build :recruitment_cycle }

  let(:course_page) { PageObjects::Page::Course.new }
  let(:url) { "/recruitment_cycles/#{Settings.current_cycle}/providers/#{course.provider_code}/courses/#{course.course_code}"}

  before do
    stub_api_v3_request(url, course.to_jsonapi)

    visit course_path(course.provider_code, course.course_code)
  end

  describe "Any course" do
    scenario "it shows the course show page" do
      expect(course_page.title).to have_content(
        "#{course.name} (#{course.course_code})",
      )
    end
  end
end
