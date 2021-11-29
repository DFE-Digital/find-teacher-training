require 'rails_helper'

describe Courses::FeesAndFinancialSupportComponent, type: :component do
  context 'Salaried courses' do
    it 'renders salaried course section if the course has a salary' do
      course = build(:course, funding_type: 'salary').decorate

      result = render_inline(described_class.new(course))

      expect(result.text).to include('Financial support is not available for this course because it comes with a salary.')
    end

    it 'does not render salaried course section if the course does not have a salary' do
      course = build(:course, funding_type: 'fee', subjects: [build(:subject, bursary_amount: '3000')]).decorate

      result = render_inline(described_class.new(course))

      expect(result.text).not_to include('Financial support is not available for this course because it comes with a salary.')
    end
  end

  context 'Courses excluded from bursary' do
    it 'renders the student loans section if the course is excluded from bursary' do
      course = build(:course, course_name: 'Drama', subjects: [build(:subject), build(:subject)]).decorate

      result = render_inline(described_class.new(course))

      expect(result.text).to include('You may be eligible for a loan while you study')
      expect(result.text).not_to include('You do not have to apply for a bursary')
    end
  end

  context 'Courses with bursary' do
    it 'renders the bursary section if the course has a bursary' do
      FeatureFlag.activate(:bursaries_and_scholarships_announced)

      course = build(:course, course_name: 'History', subjects: [build(:subject, bursary_amount: '2000'), build(:subject)]).decorate

      result = render_inline(described_class.new(course))

      expect(result.text).to include('You do not have to apply for a bursary')
    end
  end

  context 'Courses with scholarship and bursary' do
    it 'renders the scholarships and bursary section' do
      FeatureFlag.activate(:bursaries_and_scholarships_announced)

      course = build(:course, course_name: 'History', subjects: [build(:subject, bursary_amount: '2000', scholarship: '1000'), build(:subject)]).decorate

      result = render_inline(described_class.new(course))

      expect(result.text).to include('You cannot claim both a bursary and a scholarship - you can only claim one.')
    end
  end

  context 'Courses with student loans' do
    it 'renders the student loans section if the course is not salaried, does not have a bursary or scholarship and does not meet bursary exclusion criteria' do
      course = build(:course, course_name: 'Music', subjects: [build(:subject), build(:subject)]).decorate

      result = render_inline(described_class.new(course))

      expect(result.text).to include('You may be eligible for a loan while you study')
    end
  end

  context 'Fee paying courses' do
    it 'renders the fees section' do
      course = build(:course, course_name: 'Music', fee_uk_eu: '5000', fee_details: 'Some fee details', funding_type: 'fee').decorate

      result = render_inline(described_class.new(course))

      expect(result.text).to include('Some fee details')
    end
  end
end
