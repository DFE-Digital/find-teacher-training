require 'rails_helper'

describe Courses::InternationalStudentsComponent do
  context 'when the provider does not sponsor visa', type: :component do
    it 'renders correct message' do
      provider = build(
        :provider,
        can_sponsor_student_visa: false,
        can_sponsor_skilled_worker_visa: false,
      )
      result = render_inline(described_class.new(provider: provider))

      expect(result.text).to include('We cannot sponsor visas')
    end
  end

  context 'when the provider sponsors student visa', type: :component do
    it 'renders correct message' do
      provider = build(
        :provider,
        can_sponsor_student_visa: true,
        can_sponsor_skilled_worker_visa: false,
      )
      result = render_inline(described_class.new(provider: provider))

      expect(result.text).to include('We can sponsor Student visas')
    end
  end

  context 'when the provider sponsors both kinds of visa', type: :component do
    it 'renders correct message' do
      provider = build(
        :provider,
        can_sponsor_student_visa: true,
        can_sponsor_skilled_worker_visa: true,
      )
      result = render_inline(described_class.new(provider: provider))

      expect(result.text).to include('We can sponsor Student and Skilled Worker visas')
    end
  end
end
