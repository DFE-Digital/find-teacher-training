require_relative '../../app/services/deprecated_parameters_service.rb'

describe DeprecatedParametersService do
  subject { described_class.new(parameters: parameters) }

  let(:parameters) do
    {}
  end
  context 'Empty parameters' do
    it 'should return false for deprecated' do
      expect(subject.deprecated?).to be(false)
    end

    it 'should return empty parameters' do
      expect(subject.parameters).to be_empty
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

    it 'should return true for deprecated' do
      expect(subject.deprecated?).to be(true)
    end

    it 'should return expected parameters' do
      expect(subject.parameters).to eq(expected_parameters)
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

      it 'should return true for deprecated' do
        expect(subject.deprecated?).to be(true)
      end

      it 'should return expected parameters' do
        expect(subject.parameters).to eq(expected_parameters)
      end
    end
  end
end
