require 'rails_helper'

describe Courses::SummaryComponent, type: :component do
  it 'renders sub sections' do
    provider = build(:provider).decorate
    course = build(:course,
                   provider:,
                   course_length: '1 year').decorate

    result = render_inline(described_class.new(course))

    expect(result.text).to include(
      'Financial support',
      'Qualification',
      'Course length',
      'Qualification',
      'Date you can apply from',
      'Date course starts',
      'Website',
    )
  end

  context 'a course has an accrediting provider that is not the provider' do
    it 'renders the accredited body' do
      course = build(
        :course,
        provider: build(:provider),
        accrediting_provider: build(:provider),
      ).decorate

      result = render_inline(described_class.new(course))

      expect(result.text).to include(
        'Accredited body',
      )
    end
  end

  context 'the course provider and accrediting provider are the same' do
    it 'does not render the accredited body' do
      provider = build(:provider)

      course = build(
        :course,
        provider:,
        accrediting_provider: provider,
      ).decorate

      result = render_inline(described_class.new(course))

      expect(result.text).not_to include(
        'Accredited body',
      )
    end
  end
end
