require 'rails_helper'

RSpec.describe TeacherTrainingPublicAPI::SyncAllProviders do
  include StubbedRequests::ProviderNamesAndCodes

  describe '.call' do
    let(:recruitment_cycle_year) { RecruitmentCycle.previous_year }

    it 'calls TeacherTrainingPublicAPI::ProvidersCache and TeacherTrainingPublicAPI::SyncCheck' do
      cached_provider_data = [
        {
          "name": 'Working together',
          "code": '26F',
        },
        {
          "name": 'Worlingham Church of England Voluntary Controlled Primary School',
          "code": '1ZT',
        },
      ]

      allow(TeacherTrainingPublicAPI::SyncCheck).to receive(:set_last_sync)
      stub_teacher_training_api_provider_names_and_codes(recruitment_cycle_year: recruitment_cycle_year)

      described_class.call(recruitment_cycle_year: recruitment_cycle_year)

      expect(TeacherTrainingPublicAPI::ProvidersCache.read).to eq(cached_provider_data.to_json)
      expect(TeacherTrainingPublicAPI::SyncCheck).to have_received(:set_last_sync)
    end

    it 'raises a JsonApiClient::Errors::ApiError' do
      stub_teacher_training_api_provider_names_and_codes_timeout(recruitment_cycle_year: recruitment_cycle_year)

      expect { described_class.call(recruitment_cycle_year: recruitment_cycle_year) }.to raise_error(TeacherTrainingPublicAPI::SyncError)
    end
  end
end
