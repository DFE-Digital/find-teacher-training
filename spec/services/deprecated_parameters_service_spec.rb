require 'rails_helper'
require_relative '../../app/services/deprecated_parameters_service'

describe DeprecatedParametersService do
  subject(:service) { described_class.new(parameters:) }

  let(:parameters) do
    {}
  end

  context 'Empty parameters' do
    it 'returns false for deprecated' do
      expect(service.deprecated?).to be(false)
    end

    it 'returns empty parameters' do
      expect(service.parameters).to be_empty
    end
  end

  context 'With rad in parameters' do
    let(:parameters) do
      {
        'rad' => '20',
      }
    end

    let(:expected_parameters) do
      {
        'rad' => '50',
      }
    end

    it 'returns true for deprecated' do
      expect(service.deprecated?).to be(true)
    end

    it 'returns expected parameters' do
      expect(service.parameters).to eq(expected_parameters)
    end

    context 'With page in parameters' do
      let(:parameters) do
        {
          'rad' => '5',
          'page' => 1,
        }
      end

      let(:expected_parameters) do
        {
          'page' => 1,
          'rad' => '50',
        }
      end

      it 'returns true for deprecated' do
        expect(service.deprecated?).to be(true)
      end

      it 'returns expected parameters' do
        expect(service.parameters).to eq(expected_parameters)
      end
    end
  end
end
