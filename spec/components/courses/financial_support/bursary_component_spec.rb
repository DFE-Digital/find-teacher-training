require 'rails_helper'

describe Courses::FinancialSupport::BursaryComponent, type: :component do
  let(:course) { build(:course, subjects: [build(:subject, subject_name: 'primary with mathematics', bursary_amount: 3000)]).decorate }

  context "'bursaries_and_scholarships_announced' feature flag is on" do
    before do
      allow(FeatureFlag).to receive(:active?).with(:bursaries_and_scholarships_announced).and_return(true)
    end

    it 'renders bursary details' do
      result = render_inline(described_class.new(course))

      expect(result.text).to include('You’ll get a bursary of £3,000')
    end

    context 'bursary requirements' do
      it 'renders bursary requirements' do
        result = render_inline(described_class.new(course))

        expect(result.text).to include('a degree of 2:2 or above in any subject')
      end
    end
  end

  context "'bursaries_and_scholarships_announced' feature flag is off" do
    it 'does not render bursary details' do
      allow(FeatureFlag).to receive(:active?).with(:bursaries_and_scholarships_announced).and_return(false)

      result = render_inline(described_class.new(course))

      expect(result.text).not_to include('You’ll get a bursary of £3,000')
    end
  end
end
