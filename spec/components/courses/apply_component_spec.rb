require 'rails_helper'

describe Courses::ApplyComponent, type: :component do
  let(:provider) { build(:provider) }

  context 'it is mid cycle' do
    before do
      allow(CycleTimetable).to receive(:mid_cycle?).and_return(true)
    end

    it 'renders the apply button when there are vacancies' do
      course = build(:course, has_vacancies?: true, provider: provider).decorate

      result = render_inline(described_class.new(course))

      expect(result.text).to include('Apply for this course')
    end

    it "renders a 'no vacancies' warning when there are no vacancies" do
      course = build(:course, has_vacancies?: false, provider: provider).decorate

      result = render_inline(described_class.new(course))

      expect(result.text).to include('You cannot apply for this course because it has no vacancies.')
    end
  end

  context 'it is not mid cycle' do
    it 'displays that courses are currently closed' do
      allow(CycleTimetable).to receive(:mid_cycle?).and_return(false)

      course = build(:course).decorate

      result = render_inline(described_class.new(course))

      expect(result.text).to include('Courses are currently closed')
    end
  end
end
