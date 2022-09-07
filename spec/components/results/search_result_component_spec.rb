require 'rails_helper'

describe Results::SearchResultComponent, type: :component do
  let(:cycle_2022) { build(:recruitment_cycle, year: 2022) }

  context 'when the course specifies a required degree grade' do
    it 'renders correct message' do
      course = build(
        :course,
        degree_required: :two_one,
        recruitment_cycle: cycle_2022,
        provider: build(:provider),
      )
      result = render_inline(described_class.new(course:))

      expect(result.text).to include(
        'An undergraduate degree at class 2:1 or above, or equivalent',
      )
    end
  end

  context 'when the provider specifies skilled worker visa sponsorship' do
    it 'renders correct message when only one kind of visa is sponsored' do
      course = build(
        :course,
        recruitment_cycle: cycle_2022,
        funding_type: 'salary',
        can_sponsor_student_visa: false,
        can_sponsor_skilled_worker_visa: true,
        provider: build(:provider),
      )
      result = render_inline(described_class.new(course:))

      expect(result.text).to include(
        'Skilled Worker visas can be sponsored',
      )
    end
  end

  context 'when the provider specifies skilled worker visa sponsorship for an unsalaried course' do
    it 'renders visas not sponsored message' do
      course = build(
        :course,
        recruitment_cycle: cycle_2022,
        funding_type: 'fee',
        can_sponsor_student_visa: false,
        can_sponsor_skilled_worker_visa: true,
        provider: build(:provider),
      )
      result = render_inline(described_class.new(course:))

      expect(result.text).to include(
        'Visas cannot be sponsored',
      )
    end
  end

  context 'when the provider specifies student visa sponsorship' do
    it 'renders correct message when only one kind of visa is sponsored' do
      course = build(
        :course,
        recruitment_cycle: cycle_2022,
        can_sponsor_student_visa: true,
        can_sponsor_skilled_worker_visa: false,
        provider: build(:provider),
      )
      result = render_inline(described_class.new(course:))

      expect(result.text).to include(
        'Student visas can be sponsored',
      )
    end

    it 'renders correct message when neither kind of visa is sponsored' do
      course = build(
        :course,
        recruitment_cycle: cycle_2022,
        can_sponsor_student_visa: false,
        can_sponsor_skilled_worker_visa: false,
        provider: build(:provider),
      )
      result = render_inline(described_class.new(course:))

      expect(result.text).to include(
        'Visas cannot be sponsored',
      )
    end
  end

  context 'when there is an accrediting provider' do
    it 'renders correct message' do
      course = build(
        :course,
        provider: build(:provider),
        accrediting_provider: build(:provider, provider_name: 'ACME SCITT A1'),
      )
      result = render_inline(described_class.new(course:))

      expect(result.text).to include('QTS ratified by ACME SCITT A1')
    end
  end

  context 'when there is no accrediting provider' do
    it 'renders correct message' do
      course = build(
        :course,
        provider: build(:provider),
        accrediting_provider: nil,
      )
      result = render_inline(described_class.new(course:))

      expect(result.text).not_to include('QTS ratified by')
    end
  end
end
