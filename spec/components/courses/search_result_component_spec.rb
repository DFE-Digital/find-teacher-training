require 'rails_helper'

describe Courses::SearchResultComponent, type: :component do
  context 'when the course specifies a required degree grade' do
    it 'renders correct message' do
      course = build(
        :course,
        degree_required: :two_one,
        provider: build(:provider),
      )
      result = render_inline(described_class.new(course: course))

      expect(result.text).to include(
        'An undergraduate degree at class 2:1 or above, or equivalent',
      )
    end
  end

  context 'when the provider specifies visa sponsorship' do
    it 'renders correct message when only one kind of visa is sponsored' do
      course = build(
        :course,
        provider: build(:provider, can_sponsor_student_visa: true, can_sponsor_skilled_worker_visa: false),
      )
      result = render_inline(described_class.new(course: course))

      expect(result.text).to include(
        'Student visas can be sponsored',
      )
    end

    it 'renders correct message when both kinds of visa are sponsored' do
      course = build(
        :course,
        provider: build(:provider, can_sponsor_student_visa: true, can_sponsor_skilled_worker_visa: true),
      )
      result = render_inline(described_class.new(course: course))

      expect(result.text).to include(
        'Student and Skilled Worker visas can be sponsored',
      )
    end

    it 'renders correct message when neither kind of visa is sponsored' do
      course = build(
        :course,
        provider: build(:provider, can_sponsor_student_visa: false, can_sponsor_skilled_worker_visa: false),
      )
      result = render_inline(described_class.new(course: course))

      expect(result.text).to include(
        'None',
      )
    end
  end
end
