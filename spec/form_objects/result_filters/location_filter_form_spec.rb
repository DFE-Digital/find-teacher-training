require 'rails_helper'

module ResultFilters
  describe LocationFilterForm do
    before do
      stub_geocoder
    end

    describe 'Validation' do
      subject(:results_filters) { described_class.new(params) }

      context 'no option selected' do
        let(:params) { {} }

        it 'is not valid' do
          expect(results_filters.valid?).to be(false)
        end

        it 'has error' do
          results_filters.valid?
          expect(results_filters.errors).to eq(['Select an option to find courses'])
        end

        it 'has empty params' do
          results_filters.valid?
          expect(results_filters.params).to be_empty
        end
      end

      context 'unknown location' do
        let(:params) { { l: '1', lq: 'Unknown location' } }

        it 'is not valid' do
          expect(results_filters.valid?).to be(false)
        end

        it 'has error' do
          results_filters.valid?
          expect(results_filters.errors).to eq(['Postcode, town or city', 'Enter a real city, town or postcode'])
        end

        it 'has params' do
          results_filters.valid?
          expect(results_filters.params).to eq(params)
        end
      end

      context 'known location' do
        let(:params) { { l: '1', lq: 'SW1P 3BT' } }

        it 'is not valid' do
          expect(results_filters.valid?).to be(true)
        end

        it 'has no errors' do
          results_filters.valid?
          expect(results_filters.errors).to be_empty
        end

        it 'has params' do
          results_filters.valid?
          expect(results_filters.params).to eq(params)
        end
      end
    end
  end
end
