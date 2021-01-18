require 'rails_helper'

describe 'cookie banner', type: :feature do
  include StubbedRequests::Courses
  include StubbedRequests::Subjects

  let(:results_page) { PageObjects::Page::Results.new }
  let(:params) {}
  let(:subject_areas) do
    [
      build(
        :subject_area,
        subjects: [
          build(:subject, :primary, id: 1),
          build(:subject, :biology, id: 10),
          build(:subject, :english, id: 21),
          build(:subject, :mathematics, id: 25),
          build(:subject, :french, id: 34),
        ],
      ),
      build(:subject_area, :secondary),
    ]
  end

  let(:base_parameters) { results_page_parameters }

  def stub_results_request
    stub_courses(query: base_parameters, course_count: 10)
  end

  before do
    stub_results_request
    stub_subjects
    visit results_path(params)
  end

  it 'displays a cookie banner' do
    expect(results_page).to have_cookie_banner
    expect(results_page.cookie_banner).to have_accept_all_cookies
    expect(results_page.cookie_banner).to have_set_preference_link
  end

  describe 'cookies preferences' do
    it 'does not display cookie banner' do
      visit cookie_preferences_path
      expect(page).not_to have_selector('[data-qa="cookie-banner"]')
    end
  end
end
