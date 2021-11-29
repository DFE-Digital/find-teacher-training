require 'rails_helper'

describe Courses::FinancialSupport::ScholarshipAndBursaryComponent, type: :component do
  let(:course) {
    build(:course,
          subjects: [
            build(:subject,
                  subject_name: 'primary with mathematics',
                  scholarship: 2000,
                  bursary_amount: 3000,
                  early_career_payments: 2000),
          ]).decorate
  }

  context "'bursaries_and_scholarships_announced' feature flag is on" do
    before do
      allow(FeatureFlag).to receive(:active?).with(:bursaries_and_scholarships_announced).and_return(true)
    end

    it 'renders scholarship and bursary details' do
      result = render_inline(described_class.new(course))

      expect(result.text).to include('With a scholarship or bursary, you’ll also get early career payments')
    end

    context 'early career payments' do
      it 'renders additional guidance if a course has early career payments' do
        result = render_inline(described_class.new(course))

        expect(result.text).to include('With a scholarship or bursary, you’ll also get early career payments of £2,000')
      end

      it 'does not render additional guidance if a course does not have early career payments' do
        course.subjects.first.early_career_payments = nil

        result = render_inline(described_class.new(course))

        expect(result.text).not_to include('With a scholarship or bursary, you’ll also get early career payments of £2,000')
      end
    end
  end

  context "'bursaries_and_scholarships_announced' feature flag is off" do
    before do
      allow(FeatureFlag).to receive(:active?).with(:bursaries_and_scholarships_announced).and_return(false)
    end

    it 'does not render scholarship and bursary details' do
      result = render_inline(described_class.new(course))

      expect(result.text).not_to include('With a scholarship or bursary, you’ll also get early career payments')
    end
  end
end
