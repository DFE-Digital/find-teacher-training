require 'rails_helper'

describe Courses::EntryRequirementsComponent do
  context 'when the provider accepts pending GCSEs', type: :component do
    it 'renders correct message' do
      course = build(
        :course,
        accept_pending_gcse: true,
      )
      result = render_inline(described_class.new(course: course))

      expect(result.text).to include(
        'Candidates with pending GCSEs will be considered',
      )
    end
  end

  context 'when the provider does NOT accept pending GCSEs', type: :component do
    it 'renders correct message' do
      course = build(
        :course,
        accept_pending_gcse: false,
      )
      result = render_inline(described_class.new(course: course))

      expect(result.text).to include(
        'Candidates with pending GCSEs will not be considered',
      )
    end
  end

  context 'when the provider requires grade 4 and the course is secondary', type: :component do
    it 'renders correct message' do
      course = build(
        :course,
        provider: build(:provider, provider_code: 'ABC'),
        level: 'primary',
      )
      result = render_inline(described_class.new(course: course))

      expect(result.text).to include(
        'Grade 4 (C) or above in English, maths and science, or equivalent qualification',
      )
    end
  end

  context 'when the provider requires grade 5 and the course is secondary', type: :component do
    it 'renders correct message' do
      course = build(
        :course,
        provider: build(:provider, provider_code: 'U80'),
        level: 'secondary',
      )
      result = render_inline(described_class.new(course: course))

      expect(result.text).to include(
        'Grade 5 (C) or above in English and maths, or equivalent qualification.',
      )
    end
  end

  context 'when the provider does not accept equivalant GCSE grades', type: :component do
    it 'renders correct message' do
      course = build(
        :course,
        accept_gcse_equivalency: false,
        accept_english_gcse_equivalency: false,
        accept_maths_gcse_equivalency: false,
        accept_science_gcse_equivalency: false,
      )
      result = render_inline(described_class.new(course: course))

      expect(result.text).to include(
        'Equivalency tests will not be accepted.',
      )
    end
  end

  context 'when the provider accepts equivalant GCSE grades for Maths and science', type: :component do
    it 'renders correct message' do
      course = build(
        :course,
        accept_gcse_equivalency: true,
        accept_english_gcse_equivalency: false,
        accept_maths_gcse_equivalency: true,
        accept_science_gcse_equivalency: true,
      )
      result = render_inline(described_class.new(course: course))

      expect(result.text).to include(
        'Equivalency tests will be accepted in maths and science.',
      )
    end
  end

  context 'when the provider requires a 2:2 and specifies additional requirements', type: :component do
    it 'renders correct message' do
      course = build(
        :course,
        degree_grade: 'two_two',
        additional_degree_subject_requirements: true,
        degree_subject_requirements: 'Certificate must be printed on green paper.',
      )
      result = render_inline(described_class.new(course: course))

      expect(result.text).to include(
        '2:2 or above, or equivalent.',
      )
      expect(result.text).to include(
        'Certificate must be printed on green paper.',
      )
    end
  end
end
