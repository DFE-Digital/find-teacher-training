require 'rails_helper'

describe 'Course show', type: :feature do
  let(:provider) do
    build(
      :provider,
      provider_name: 'ACME SCITT A0',
      provider_code: 'T92',
      provider_type: 'scitt',
      website: 'https://scitt.org',
      address1: '1 Long Rd',
      postcode: 'E1 ABC',
      can_sponsor_student_visa: true,
      can_sponsor_skilled_worker_visa: false,
    )
  end
  let(:accrediting_provider) { build(:provider) }
  let(:decorated_course) { course.decorate }

  let(:course) do
    build(
      :course,
      name: 'Primary',
      course_code: 'X130',
      provider:,
      provider_code: provider.provider_code,
      provider_type: provider.provider_type,
      recruitment_cycle: current_recruitment_cycle,
      accrediting_provider:,
      age_range_in_years: '11_to_16',
      course_length: 'OneYear',
      applications_open_from: '2019-01-01T00:00:00Z',
      start_date: '2019-09-01T00:00:00Z',
      fee_uk_eu: '9250.0',
      fee_international: '9250.0',
      fee_details: 'Optional fee details',
      has_scholarship_and_bursary?: true,
      financial_support: 'Some info about financial support',
      scholarship_amount: '20000',
      bursary_amount: '22000',
      personal_qualities: 'We are looking for ambitious trainee teachers who are passionate and enthusiastic about their subject and have a desire to share that with young people of all abilities in this particular age range.',
      other_requirements: 'You will need three years of prior work experience, but not necessarily in an educational context.',
      about_accrediting_body: 'Something great about the accredited body',
      interview_process: 'Some helpful guidance about the interview process',
      how_school_placements_work: 'Some info about how school placements work',
      about_course: 'This is a course',
      required_qualifications: 'You need some qualifications for this course',
      has_vacancies?: true,
      site_statuses: [
        jsonapi_site_status('Running site with vacancies', :full_time, 'running'),
        jsonapi_site_status('Suspended site with vacancies', :full_time, 'suspended'),
        jsonapi_site_status('New site with vacancies', :full_time, 'new_status'),
        jsonapi_site_status('New site with no vacancies', :no_vacancies, 'new_status'),
        jsonapi_site_status('Running site with no vacancies', :no_vacancies, 'running'),
      ],
      subjects: [subject],
      degree_grade: 'two_one',
      additional_degree_subject_requirements: true,
      degree_subject_requirements: 'Certificate must be print in blue ink',
      accept_pending_gcse: true,
      accept_gcse_equivalency: true,
      accept_english_gcse_equivalency: true,
      accept_maths_gcse_equivalency: false,
      accept_science_gcse_equivalency: false,
      additional_gcse_equivalencies: 'You need to work hard',
    )
  end

  let(:current_recruitment_cycle) { build :recruitment_cycle, year: RecruitmentCycle.current_year }

  let(:course_page) { PageObjects::Page::Course.new }

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
    FeatureFlag.activate(:bursaries_and_scholarships_announced)

    stub_api_v3_resource(
      type: RecruitmentCycle,
      params: {
        recruitment_cycle_year: RecruitmentCycle.current_year,
      },
      resources: current_recruitment_cycle,
    )

    stub_api_v3_resource(
      type: Course,
      params: {
        recruitment_cycle_year: RecruitmentCycle.current_year,
        provider_code: course.provider_code,
        provider_type: course.provider_type,
        course_code: course.course_code,
      },
      resources: course,
      include: ['subjects', 'site_statuses.site', 'provider.sites', 'accrediting_provider'],
    )
    visit course_path(course.provider_code, course.course_code)
  end

  describe 'Any course' do
    it 'shows the course show page' do
      expect(course_page.title).to have_content(
        "#{course.name} (#{course.course_code})",
      )

      expect(course_page.sub_title).to have_content(
        provider.provider_name,
      )

      expect(course_page.accredited_body).to have_content(
        accrediting_provider.provider_name,
      )

      expect(course_page.description).to have_content(
        course.description,
      )

      expect(course_page.qualifications).to have_content(
        'PGCE with QTS',
      )

      expect(course_page.age_range).to have_content(
        '11 to 16',
      )

      expect(course_page.funding_option).to have_content(
        decorated_course.funding_option,
      )

      expect(course_page.length).to have_content(
        decorated_course.length,
      )

      expect(course_page.applications_open_from).to have_content(
        '1 January 2019',
      )

      expect(course_page.start_date).to have_content(
        'September 2019',
      )

      expect(course_page.provider_website).to have_content(
        provider.website,
      )

      expect(course_page).not_to have_vacancies

      expect(course_page.about_course).to have_content(
        course.about_course,
      )

      expect(course_page.interview_process).to have_content(
        course.interview_process,
      )

      expect(course_page.school_placements).to have_content(
        course.how_school_placements_work,
      )

      expect(course_page.uk_fees).to have_content(
        '£9,250',
      )

      expect(course_page.international_fees).to have_content(
        '£9,250',
      )

      expect(course_page.fee_details).to have_content(
        decorated_course.fee_details,
      )

      expect(course_page).not_to have_salary_details

      expect(course_page.scholarship_amount).to have_content('a scholarship of £2,000')

      expect(course_page.bursary_amount).to have_content('a bursary of £4,000')

      expect(course_page.financial_support_details).to have_content('Financial support from the training provider')

      expect(course_page.required_qualifications).not_to have_content(
        course.required_qualifications,
      )

      expect(course_page).to have_international_students
      expect(course_page.international_students).to have_content(
        'Before you apply for this course, contact us to check Student visa sponsorship is available. If it is, and you get a place on this course, we’ll help you apply for your visa.',
      )

      expect(course_page.required_qualifications).to have_content(
        'Grade 4 (C) or above in English and maths, or equivalent qualification.',
      )
      expect(course_page.required_qualifications).to have_content(
        'We’ll consider candidates with pending GCSEs.',
      )
      expect(course_page.required_qualifications).to have_content(
        'We’ll consider candidates who need to take a GCSE equivalency test in English.',
      )
      expect(course_page.required_qualifications).to have_content(
        'You need to work hard',
      )

      expect(course_page.required_qualifications).to have_content(
        '2:1 or above, or equivalent.',
      )
      expect(course_page.required_qualifications).to have_content(
        'Certificate must be print in blue ink',
      )

      expect(course_page.personal_qualities).to have_content(
        course.personal_qualities,
      )

      expect(course_page.other_requirements).to have_content(
        course.other_requirements,
      )

      expect(course_page.train_with_us).to have_content(
        provider.train_with_us,
      )

      expect(course_page.about_accrediting_body).to have_content(
        course.about_accrediting_body,
      )

      expect(course_page.train_with_disability).to have_content(
        provider.train_with_disability,
      )

      expect(course_page.contact_email).to have_content(
        provider.email,
      )

      expect(course_page.contact_telephone).to have_content(
        provider.telephone,
      )

      expect(course_page.contact_website).to have_content(
        provider.website,
      )

      expect(course_page.contact_address).to have_content(
        '1 Long Rd E1 ABC',
      )

      expect(course_page.school_placements).not_to have_content('Suspended site with vacancies')

      course.site_statuses.map(&:site).uniq.each do |site|
        expect(course_page).to have_content(site.decorate.full_address)
      end

      expect(course_page).to have_course_advice

      expect(course_page.apply_link.text).to eq('Apply for this course')

      expect(course_page.apply_link[:href]).to eq('/course/T92/X130/apply')

      expect(course_page).not_to have_content('When you apply you’ll need these codes for the Choices section of your application form')

      expect(course_page).not_to have_end_of_cycle_notice

      expect(course_page.feedback_link[:href]).to eq('https://www.apply-for-teacher-training.service.gov.uk/candidate/find-feedback?path=/course/T92/X130&find_controller=courses')
    end

    context 'End of cycle' do
      before do
        Timecop.freeze(CycleTimetable.apply_2_deadline + 1.hour)
        visit course_path(course.provider_code, course.course_code)
      end

      after do
        Timecop.return
      end

      it "does not display the 'apply for this course' button" do
        expect(course_page).not_to have_apply_link
        expect(course_page).to have_end_of_cycle_notice
      end

      it 'renders the deadline banner' do
        expect(page).to have_content 'Courses are currently closed but you can get your application ready'
      end
    end
  end

  describe 'A course without international fees' do
    let(:course) do
      build(:course,
            course_code: 'X130',
            fee_uk_eu: '9250.0',
            fee_international: nil,
            provider:,
            provider_code: provider.provider_code,
            provider_type: provider.provider_type,
            recruitment_cycle: current_recruitment_cycle,
            accrediting_provider:)
    end

    it 'only displays uk fees' do
      expect(course_page).to have_content(
        "The course fees for UK students in #{RecruitmentCycle.current_year} to #{RecruitmentCycle.current_year + 1} are £9,250",
      )

      expect(course_page).not_to have_international_fees
    end
  end

  describe 'Showing the back button' do
    context 'When navigating directly to the course' do
      it 'Does not display the back link' do
        expect(course_page).not_to have_back_link
      end
    end

    context 'When navigating to the course from the current application' do
      let(:referer) { "http://#{page.driver.request.host_with_port}/results" }

      it 'Does displays the back link' do
        page.driver.header('Referer', referer)
        visit course_path(course.provider_code, course.course_code)
        expect(course_page).to have_back_link
        expect(course_page.back_link[:href]).to eq referer
      end
    end
  end

  def jsonapi_site_status(name, study_mode, status)
    build(:site_status, study_mode, site: build(:site, location_name: name), status:)
  end
end
