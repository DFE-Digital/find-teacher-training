require 'rails_helper'

describe Courses::InternationalStudentsComponent do
  context 'when the provider does not sponsor visa', type: :component do
    it 'renders correct message' do
      provider = build(
        :provider,
        can_sponsor_student_visa: false,
        can_sponsor_skilled_worker_visa: false,
      )
      course = build(
        :course,
        funding_type: 'fee',
        provider: provider,
      )
      result = render_inline(described_class.new(course: CourseDecorator.new(course)))

      expect(result.text).to include('We cannot sponsor visas. You will need to get the right visa or status to study in the UK')
      expect(result).to have_selector("a[href='#{described_class::TRAIN_TO_TEACH_URL}']")
    end
  end

  context 'when the provider sponsors student visa the course is not salaried', type: :component do
    it 'renders correct message' do
      provider = build(
        :provider,
        can_sponsor_student_visa: true,
        can_sponsor_skilled_worker_visa: false,
      )
      course = build(
        :course,
        funding_type: 'fee',
        provider: provider,
      )
      result = render_inline(described_class.new(course: CourseDecorator.new(course)))

      expect(result.text).to include('We can sponsor Student visas, but this is not guaranteed.')
      expect(result).to have_selector("a[href='#{described_class::TRAIN_TO_TEACH_URL}']")
    end
  end

  context 'when the provider sponsors both kinds of visa and the course is salaried', type: :component do
    it 'renders correct message' do
      provider = build(
        :provider,
        can_sponsor_student_visa: true,
        can_sponsor_skilled_worker_visa: true,
      )
      course = build(
        :course,
        funding_type: 'salary',
        provider: provider,
      )
      result = render_inline(described_class.new(course: CourseDecorator.new(course)))

      expect(result.text).to include('We can sponsor Skilled Worker visas, but this is not guaranteed.')
      expect(result).to have_selector("a[href='#{described_class::TRAIN_TO_TEACH_URL}']")
    end
  end
end
