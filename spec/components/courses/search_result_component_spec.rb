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
end
