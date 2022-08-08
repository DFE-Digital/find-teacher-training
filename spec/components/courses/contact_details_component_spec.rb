require 'rails_helper'

describe Courses::ContactDetailsComponent, type: :component do
  context 'contact details for London School of Jewish Studies and the course code is X104' do
    it 'renders the custom address requested via zendesk' do
      provider = build(:provider, provider_code: '28T')
      course = build(:course, course_code: 'X104', provider:).decorate

      result = render_inline(described_class.new(course))

      expect(result.text).to include('LSJS', '44A Albert Road', 'London', 'NW4 2SJ')
    end
  end
end
