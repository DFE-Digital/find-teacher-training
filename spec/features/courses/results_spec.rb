require 'rails_helper'

describe 'Search results', type: :feature do
  include StubbedRequests::Courses
  include StubbedRequests::Subjects

  let(:results_page) { PageObjects::Page::Results.new }
  let(:accrediting_provider) { build(:provider) }
  let(:decorated_course) { course.decorate }
  let(:courses) { [course] }
  let(:page_index) { nil }
  let(:stub_courses_request) do
    stub_courses(query: base_parameters, course_count: 10)
  end

  let(:base_parameters) { results_page_parameters }

  subject do
    build(
      :subject,
      :english,
      scholarship: '2000',
      bursary_amount: '4000',
      early_career_payments: '1000',
    )
  end

  before do
    stub_subjects
    stub_courses_request

    visit results_path(page: page_index)
  end

  it 'requests the courses' do
    expect(stub_courses_request).to have_been_requested
  end

  context 'multiple courses' do
    it 'Lists all courses' do
      expect(results_page.courses.count).to eq(10)

      results_page.courses.first.then do |first_course|
        expect(first_course.name.text).to eq('Primary (5-11) with SEND (H411)')
        expect(first_course.provider_name.text).to eq('Linwood Training, Support and Advice')
        expect(first_course.qualification.text).to include('PGCE with QTS')
        expect(first_course.study_mode.text).to eq('Full time')
        expect(first_course.funding_options.text).to eq('Student finance if you’re eligible')
        expect(first_course.main_address.text).to eq('Poole SCITT, Ad Astra Infant School, Sherborn Crescent, Poole, Dorset, BH17 8AP')
        expect(first_course).not_to have_show_vacancies
      end
    end
  end

  context 'with a second page' do
    before do
      base_parameters.merge(page_index: 2)
    end

    it 'requests the second page' do
      expect(stub_courses_request).to have_been_requested
    end
  end

  context 'with courses API caching' do
    it 'shows the same search results until the cache expires' do
      expect(results_page.courses.count).to eq(10)
      stub_courses(query: base_parameters, course_count: 4)

      not_yet_expired = Course::TTAPI_CALLS_EXPIRY - 1.minute
      Timecop.travel(Time.zone.now + not_yet_expired)
      results_page.load
      expect(results_page.courses.count).to eq(10)

      Timecop.travel(Time.zone.now + 1.minute)
      results_page.load
      expect(results_page.courses.count).to eq(4)
    end
  end
end
