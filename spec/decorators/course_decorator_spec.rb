require 'rails_helper'

describe CourseDecorator do
  let(:current_recruitment_cycle) { build(:recruitment_cycle) }
  let(:next_recruitment_cycle) { build(:recruitment_cycle, :next_cycle) }
  let(:provider) do
    build(
      :provider,
      accredited_body?: false,
      website: 'www.acmescitt.com',
    )
  end
  let(:english) { build(:subject, :english) }
  let(:biology) { build(:subject, :biology) }
  let(:mathematics) { build(:subject, :mathematics) }
  let(:subjects) { [english, mathematics] }
  let(:campaign_name) { nil }

  let(:course) do
    build(:course,
          course_code: 'A1',
          name: 'Mathematics',
          qualification: 'pgce_with_qts',
          study_mode: 'full_time',
          start_date:,
          site_statuses: [site_status],
          provider:,
          accrediting_provider: provider,
          course_length: 'OneYear',
          subjects:,
          open_for_applications?: true,
          last_published_at: '2019-03-05T14:42:34Z',
          recruitment_cycle: current_recruitment_cycle,
          has_vacancies?: true,
          campaign_name:)
  end
  let(:start_date) { Time.zone.local(2019) }
  let(:site) { build(:site) }
  let(:site_status) do
    build(:site_status, :full_time_and_part_time, site:)
  end

  let(:course_response) do
    resource_to_jsonapi(
      course,
      include: %i[sites provider accrediting_provider recruitment_cycle subjects],
    )
  end

  let(:decorated_course) { course.decorate }

  it 'returns the course name and code in brackets' do
    expect(decorated_course.name_and_code).to eq('Mathematics (A1)')
  end

  it 'returns if course is an apprenticeship' do
    expect(decorated_course.apprenticeship?).to be(false)
  end

  it 'returns course length' do
    expect(decorated_course.length).to eq('1 year')
  end

  describe '#salaried?' do
    subject { decorated_course }

    context 'course is salaried' do
      let(:course) { build(:course, funding_type: 'salary') }

      it { is_expected.to be_salaried }
    end

    context 'course is an apprenticeship with salary' do
      let(:course) { build(:course, funding_type: 'apprenticeship') }

      it { is_expected.to be_salaried }
    end

    context 'course is not salaried' do
      let(:course) { build(:course, :with_fees) }

      it { is_expected.not_to be_salaried }
    end
  end

  describe '#engineers_teach_physics?' do
    subject { decorated_course.engineers_teach_physics? }

    context 'campaign_name is set to nil' do
      it { is_expected.to be_falsey }
    end

    context 'campaign_name is set to engineers_teach_physics' do
      let(:campaign_name) { 'engineers_teach_physics' }

      it { is_expected.to be_truthy }
    end
  end

  describe '#funding_option' do
    subject { decorated_course.funding_option }

    context 'Salary' do
      let(:course) { build(:course, funding_type: 'salary') }

      it { is_expected.to eq('Salary') }
    end

    context 'Apprenticeship' do
      let(:course) { build(:course, funding_type: 'apprenticeship') }

      it { is_expected.to eq('Salary') }
    end

    context 'Bursary and Scholarship' do
      let(:mathematics) { build(:subject, :mathematics, scholarship: '2000', bursary_amount: '3000') }
      let(:course) { build(:course, subjects: [mathematics]) }

      before { FeatureFlag.activate(:bursaries_and_scholarships_announced) }

      it { is_expected.to eq('Scholarships or bursaries, as well as student finance, are available if you’re eligible') }

      context 'when bursaries_and_scholarships_announced feature is off' do
        before { FeatureFlag.deactivate(:bursaries_and_scholarships_announced) }

        it { is_expected.to eq('Student finance if you’re eligible') }
      end
    end

    context 'Bursary' do
      let(:mathematics) { build(:subject, :mathematics, bursary_amount: '3000') }
      let(:course) { build(:course, subjects: [mathematics]) }

      before { FeatureFlag.activate(:bursaries_and_scholarships_announced) }

      it { is_expected.to eq('Bursaries and student finance are available if you’re eligible') }

      context 'when bursaries_and_scholarships_announced feature is off' do
        before { FeatureFlag.deactivate(:bursaries_and_scholarships_announced) }

        it { is_expected.to eq('Student finance if you’re eligible') }
      end
    end

    context 'Student finance' do
      let(:course) { build(:course) }

      it { is_expected.to eq('Student finance if you’re eligible') }
    end

    context 'Courses excluded from bursaries' do
      let(:pe) { build(:subject) }
      let(:english) { build(:subject, :english, bursary_amount: '3000') }

      let(:course) { build(:course, name: 'Drama with English', subjects: [pe, english]) }

      it { is_expected.to eq('Student finance if you’re eligible') }
    end
  end

  describe '#subject_name' do
    context 'course has more than one subject' do
      it 'returns the course name' do
        expect(decorated_course.subject_name).to eq('Mathematics')
      end
    end

    context 'course has one subject' do
      subject { build(:subject, subject_name: 'Computer Science') }

      let(:course) { build(:course, subjects: [subject]) }

      it 'return the subject name' do
        expect(decorated_course.subject_name).to eq('Computer Science')
      end
    end
  end

  describe '#subject_name_or_names' do
    context 'course has more than one subject' do
      it "returns both subjects names seperated by a 'with'" do
        expect(decorated_course.computed_subject_name_or_names).to eq('English with mathematics')
      end
    end

    context 'course has one subject' do
      subject { build(:subject, subject_name: 'Computer Science') }

      let(:course) { build(:course, subjects: [subject]) }

      it 'return the subject name' do
        expect(decorated_course.computed_subject_name_or_names).to eq('computer science')
      end
    end

    context 'course has a language subject' do
      subject { build(:subject, :english) }

      let(:course) { build(:course, subjects: [subject]) }

      it 'return the capitalised subject name' do
        expect(decorated_course.computed_subject_name_or_names).to eq('English')
      end
    end

    context 'course is modern languages' do
      subject { build(:subject, :modern_languages) }

      let(:course) { build(:course, subjects: [subject, build(:subject, :french)]) }

      it 'return lowercase modern languages and capitalised language' do
        expect(decorated_course.computed_subject_name_or_names).to eq('modern languages with French')
      end
    end

    context 'course is modern languages (other)' do
      subject { build(:subject, :modern_languages) }

      let(:course) { build(:course, subjects: [subject, build(:subject, subject_name: 'Modern languages (other)', subject_code: '24')]) }

      it 'return one modern languages' do
        expect(decorated_course.computed_subject_name_or_names).to eq('modern languages')
      end
    end
  end

  describe '#bursary_requirements' do
    subject { decorated_course.bursary_requirements }

    context 'Course with mathematics as a subject' do
      let(:mathematics) { build(:subject, :mathematics, subject_name: 'Primary with Mathematics') }
      let(:english) { build(:subject, :english) }
      let(:subjects) { [mathematics, english] }

      expected_requirements = [
        'a degree of 2:2 or above in any subject',
        'at least grade B in maths A-level (or an equivalent)',
      ]

      it { is_expected.to eq(expected_requirements) }
    end

    context 'Course without mathematics as a subject' do
      let(:english) { build(:subject, :english) }
      let(:subjects) { [biology, english] }

      expected_requirements = [
        'a degree of 2:2 or above in any subject',
      ]

      it { is_expected.to eq(expected_requirements) }
    end
  end

  describe '#bursary_first_line_ending' do
    subject { decorated_course.bursary_first_line_ending }

    context 'More than one requirement' do
      let(:mathematics) { build(:subject, :mathematics, subject_name: 'Primary with Mathematics') }
      let(:english) { build(:subject, :english) }
      let(:subjects) { [mathematics, english] }

      expected_line_ending = ':'

      it { is_expected.to eq(expected_line_ending) }
    end

    context 'Course without mathematics as a subject' do
      let(:english) { build(:subject, :english) }
      let(:subjects) { [biology, english] }

      expected_line_ending = 'a degree of 2:2 or above in any subject.'

      it { is_expected.to eq(expected_line_ending) }
    end
  end

  describe '#bursary_only' do
    subject { decorated_course }

    context 'course only has bursary financial incentives' do
      let(:mathematics) { build(:subject, bursary_amount: '2000') }
      let(:english) { build(:subject, bursary_amount: '4000') }
      let(:subjects) { [mathematics, english] }

      it { is_expected.to be_bursary_only }
    end

    context 'course has other financial incentives apart from bursaries' do
      let(:mathematics) { build(:subject, bursary_amount: '2000') }
      let(:english) { build(:subject, scholarship: '4000') }
      let(:subjects) { [mathematics, english] }

      it { is_expected.not_to be_bursary_only }
    end
  end

  describe '#has_bursary' do
    context 'course has no bursary' do
      it 'returns false' do
        expect(decorated_course.has_bursary?).to be(false)
      end
    end

    context 'course has bursary' do
      let(:mathematics) { build(:subject, bursary_amount: '2000') }
      let(:english) { build(:subject, bursary_amount: '4000') }
      let(:subjects) { [biology, mathematics, english] }

      it 'returns true' do
        expect(decorated_course.has_bursary?).to be(true)
      end
    end
  end

  describe '#bursary_amount' do
    context 'course has bursary' do
      let(:mathematics) { build(:subject, bursary_amount: '2000') }
      let(:english) { build(:subject, bursary_amount: '4000') }
      let(:subjects) { [biology, mathematics, english] }

      it 'returns the maximum bursary amount' do
        expect(decorated_course.bursary_amount).to eq('4000')
      end
    end
  end

  describe '#excluded_from_bursary?' do
    subject { decorated_course }

    let(:english) { build(:subject, bursary_amount: '30000') }
    let(:drama) { build(:subject, subject_name: 'Drama') }
    let(:pe) { build(:subject, subject_name: 'PE') }
    let(:physical_education) { build(:subject, subject_name: 'Physical Education') }
    let(:media_studies) { build(:subject, subject_name: 'Media Studies') }

    context 'course name does not qualify for exclusion' do
      let(:course) { build(:course, name: 'Mathematics') }

      it { is_expected.not_to be_excluded_from_bursary }
    end

    context "course name contains 'Drama with English'" do
      let(:subjects) { [english, drama] }
      let(:course) { build(:course, name: 'Drama with English', subjects:) }

      it { is_expected.to be_excluded_from_bursary }
    end

    context "course name contains 'English with Drama'" do
      let(:subjects) { [english, drama] }
      let(:course) { build(:course, name: 'English with Drama', subjects:) }

      it { is_expected.not_to be_excluded_from_bursary }
    end

    context "course name contains 'PE with English'" do
      let(:subjects) { [english, pe] }
      let(:course) { build(:course, name: 'PE with English', subjects:) }

      it { is_expected.to be_excluded_from_bursary }
    end

    context "course name contains 'English with PE'" do
      let(:subjects) { [english, pe] }
      let(:course) { build(:course, name: 'English with PE', subjects:) }

      it { is_expected.not_to be_excluded_from_bursary }
    end

    context "course name contains 'Physical Education with English'" do
      let(:subjects) { [english, physical_education] }
      let(:course) { build(:course, name: 'Physical Education with English', subjects:) }

      it { is_expected.to be_excluded_from_bursary }
    end

    context "course name contains 'English with Physical Education'" do
      let(:subjects) { [english, physical_education] }
      let(:course) { build(:course, name: 'English with Physical Education', subjects:) }

      it { is_expected.not_to be_excluded_from_bursary }
    end

    context "course name contains 'Media Studies with English'" do
      let(:subjects) { [english, media_studies] }
      let(:course) { build(:course, name: 'Media Studies with English', subjects:) }

      it { is_expected.to be_excluded_from_bursary }
    end

    context "course name contains 'English with Media Studies'" do
      let(:subjects) { [english, media_studies] }
      let(:course) { build(:course, name: 'English with Media Studies', subjects:) }

      it { is_expected.not_to be_excluded_from_bursary }
    end

    context "course name contains 'Drama and English'" do
      let(:subjects) { [english, drama] }
      let(:course) { build(:course, name: 'Drama and English', subjects:) }

      it { is_expected.not_to be_excluded_from_bursary }
    end

    context "course name contains 'English and Drama'" do
      let(:subjects) { [english, drama] }
      let(:course) { build(:course, name: 'English and Drama', subjects:) }

      it { is_expected.not_to be_excluded_from_bursary }
    end
  end

  describe '#scholarship_amount' do
    context 'course has scholarship' do
      let(:mathematics) { build(:subject, scholarship: '2000') }
      let(:english) { build(:subject, scholarship: '4000') }
      let(:subjects) { [biology, mathematics, english] }

      it 'returns the maximum scholarship amount' do
        expect(decorated_course.scholarship_amount).to eq('4000')
      end
    end
  end

  describe '#has_scholarship?' do
    context 'course has no scholarship' do
      it 'returns false' do
        expect(decorated_course.has_scholarship?).to be(false)
      end
    end

    context 'course has scholarship' do
      let(:mathematics) { build(:subject, scholarship: '6000') }
      let(:english) { build(:subject, scholarship: '8000') }
      let(:subjects) { [biology, mathematics, english] }

      it 'returns true' do
        expect(decorated_course.has_scholarship?).to be(true)
      end
    end
  end

  context 'early careers payment option' do
    context 'course has no early career payment option' do
      it 'returns false' do
        expect(decorated_course.has_early_career_payments?).to be(false)
      end
    end

    context 'course has early career payment option' do
      let(:english) { build(:subject, early_career_payments: '2000') }
      let(:subjects) { [biology, mathematics, english] }

      it 'returns true' do
        expect(decorated_course.has_early_career_payments?).to be(true)
      end
    end
  end

  describe '#display_title' do
    it 'returns the course name with the course code' do
      expect(decorated_course.display_title).to eq('Mathematics (A1)')
    end
  end

  describe '#year_range' do
    it 'returns correct year range' do
      expect(decorated_course.year_range).to eq("#{RecruitmentCycle.current_year} to #{RecruitmentCycle.current_year + 1}")
    end
  end

  describe '#placements_heading' do
    context 'when subject is primary' do
      let(:course) { build(:course) }

      it 'returns school placement' do
        expect(decorated_course.placements_heading).to eq('School placements')
      end
    end

    context 'when further education' do
      let(:course) { build(:course, :further_education) }

      it 'returns teaching placement' do
        expect(decorated_course.placements_heading).to eq('Teaching placements')
      end
    end
  end
end
