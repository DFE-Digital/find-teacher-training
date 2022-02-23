require 'rails_helper'

describe Courses::FinancialSupport::BursaryComponent, type: :component do
  let(:course) { build(:course, subjects: [build(:subject, subject_name: 'primary with mathematics', bursary_amount: 3000)]).decorate }

  context "'bursaries_and_scholarships_announced' feature flag is on" do
    before do
      allow(FeatureFlag).to receive(:active?).with(:bursaries_and_scholarships_announced).and_return(true)
      render_inline(described_class.new(course))
    end

    it 'renders bursary details' do
      expect(rendered_component).to have_text('You’ll get a bursary of £3,000')
    end

    context 'bursary requirements' do
      it 'renders bursary requirements' do
        expect(rendered_component).to have_text('a degree of 2:2 or above in any subject')
      end
    end

    describe '#duplicate_requirements' do
      let(:requirement) { 'a degree of 2:2 or above in any subject' }

      context 'requirement and bursary_first_line_ending are identical' do
        let(:course) { build(:course, subjects: [build(:subject, :modern_languages, bursary_amount: 3000)]).decorate }

        it 'does not render duplicate bursary requirements' do
          expect(rendered_component).to have_no_css('ul.govuk-list.govuk-list--bullet', text: 'a degree of 2:2 or above in any subject')
          expect(described_class.new(course).duplicate_requirement(requirement)).to be_truthy
        end
      end

      context 'requirement and bursary_first_line_ending are not identical' do
        it 'renders both requirement and bursary first line ending' do
          expect(rendered_component).to have_css('ul.govuk-list.govuk-list--bullet', text: 'a degree of 2:2 or above in any subject')
          expect(described_class.new(course).duplicate_requirement(requirement)).to be_falsey
        end
      end
    end
  end

  context "'bursaries_and_scholarships_announced' feature flag is off" do
    it 'does not render bursary details' do
      allow(FeatureFlag).to receive(:active?).with(:bursaries_and_scholarships_announced).and_return(false)

      render_inline(described_class.new(course))

      expect(rendered_component).not_to have_text('You’ll get a bursary of £3,000')
    end
  end
end
