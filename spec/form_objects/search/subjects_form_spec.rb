require 'rails_helper'

module Search
  describe SubjectsForm do
    describe 'validation' do
      it 'is not valid when subject codes are not present' do
        form = Search::SubjectsForm.new

        expect(form.valid?).to be(false)
      end

      it 'is valid when subject codes are present' do
        form = Search::SubjectsForm.new(subject_codes: %w[01 02])

        expect(form.valid?).to be(true)
      end
    end
  end
end
