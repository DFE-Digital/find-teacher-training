require 'rails_helper'

module Search
  describe StartForm do
    describe 'validation' do
      it 'is not valid if search type is not present' do
        form = described_class.new

        expect(form.valid?).to be(false)
      end

      context 'location search' do
        it 'is not valid if location query is not present' do
          form = described_class.new(l: '1')

          expect(form.valid?).to be(false)
        end

        it 'is valid if location query is present' do
          form = described_class.new(l: 'location', lq: 'Newcastle')

          expect(form.valid?).to be(true)
        end
      end

      context 'provider search' do
        it 'is not valid if provider query is not present' do
          form = described_class.new(l: '3')

          expect(form.valid?).to be(false)
        end

        it 'is valid if provider query is present' do
          form = described_class.new(l: '2', query: 'Gorse SCITT')

          expect(form.valid?).to be(true)
        end
      end
    end
  end
end
