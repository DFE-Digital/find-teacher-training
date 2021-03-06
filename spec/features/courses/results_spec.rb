require 'rails_helper'

describe 'Search results', type: :feature do
  include StubbedRequests::Courses
  include StubbedRequests::Subjects

  let(:results_page) { PageObjects::Page::Results.new }

  let(:base_parameters) { results_page_parameters }

  let(:subject) do
    build(
      :subject,
      :english,
      scholarship: '2000',
      bursary_amount: '4000',
      early_career_payments: '1000',
    )
  end

  let(:accrediting_provider) { build(:provider) }
  let(:decorated_course) { course.decorate }
  let(:courses) { [course] }

  let(:page_index) { nil }

  let(:stub_courses_request) do
    stub_courses(query: base_parameters, course_count: 10)
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
        expect(first_course.name.text).to eq('Geography (385N)')
        expect(first_course.provider_name.text).to eq('BHSSA')
        expect(first_course.qualification.text).to eq('PGCE with QTS')
        expect(first_course.study_mode.text).to eq('Full time')
        expect(first_course.accrediting_provider.text).to eq('University of Brighton')
        expect(first_course.funding_options.text).to eq('Student finance if you’re eligible')
        expect(first_course.main_address.text).to eq('Hove Park School, Hangleton Way, Hove, East Sussex, BN3 8AA')
        expect(first_course).to have_show_vacancies
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
end
