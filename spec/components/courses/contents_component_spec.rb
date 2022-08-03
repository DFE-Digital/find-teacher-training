require 'rails_helper'

describe Courses::ContentsComponent, type: :component do
  context "when the program type is 'higher_education_programme'" do
    it 'renders the schools section link' do
      provider = build(:provider).decorate

      course = build(
        :course,
        provider:,
        program_type: 'higher_education_programme',
      ).decorate

      result = render_inline(described_class.new(course))

      expect(result.text).to include('School placements')
    end
  end

  context "when the program type is 'scitt_programme'" do
    it 'renders the schools section link' do
      provider = build(:provider).decorate

      course = build(
        :course,
        provider:,
        program_type: 'scitt_programme',
      ).decorate

      result = render_inline(described_class.new(course))

      expect(result.text).to include('School placements')
    end
  end

  context "when the program type neither one of 'higher education' or 'scitt_progammw'" do
    it 'does not render the school section link' do
      provider = build(:provider).decorate

      course = build(
        :course,
        provider:,
        program_type: 'tv_programme',
      ).decorate

      result = render_inline(described_class.new(course))

      expect(result.text).not_to include('School placements')
    end
  end

  context 'when the course has vacancies' do
    it 'does render the apply link' do
      provider = build(:provider).decorate
      course = build(:course, has_vacancies?: true, provider:).decorate
      result = render_inline(described_class.new(course))

      expect(result.text).to include('Apply')
    end
  end

  context 'when the course does not have vacancies' do
    it 'does not render the apply link' do
      provider = build(:provider).decorate
      course = build(:course, has_vacancies?: false, provider:).decorate

      result = render_inline(described_class.new(course))

      expect(result.text).not_to include('Apply')
    end
  end
end
