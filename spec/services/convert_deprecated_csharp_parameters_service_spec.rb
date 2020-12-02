require 'rails_helper'

RSpec.describe ConvertDeprecatedCsharpParametersService do
  let(:service) { described_class.new }
  let(:service_call) { service.call(parameters: input_parameters) }

  context 'given deprecated parameters' do
    let(:input_parameters) do
      {
        'fulltime' => 'True',
        'hasvacancies' => 'True',
        'parttime' => 'True',
        'senCourses' => 'True',
        'qualifications' => 'QtsOnly,PgdePgceWithQts,Other',
        'subjects' => '1,2,3',
      }
    end

    it 'flags that the parameters are deprecated' do
      expect(service_call[:deprecated]).to eq(true)
    end

    it 'returns the correct parameters' do
      expect(service_call[:parameters]).to eq({
        'fulltime' => true,
        'hasvacancies' => true,
        'parttime' => true,
        'senCourses' => true,
        'qualifications' => %w[QtsOnly PgdePgceWithQts Other],
        'subjects' => %w[1 2 3],
      })
    end
  end

  context 'given supported parameters' do
    let(:input_parameters) do
      {
        'fulltime' => 'true',
        'hasvacancies' => 'true',
        'parttime' => 'true',
        'senCourses' => 'true',
        'qualifications' => %w[QtsOnly PgdePgceWithQts Other],
        'subjects' => %w[1 2 3],
      }
    end

    it 'does not flag that the parameters are deprecated' do
      expect(service_call[:deprecated]).to eq(false)
    end

    it 'returns the same parameters' do
      expect(service_call[:parameters]).to eq(input_parameters)
    end
  end
end
