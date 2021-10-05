require 'rails_helper'

RSpec.describe SyncProvidersJob do

  describe '#perform' do
    it 'calls TeacherTrainingPublicAPI::SyncAllProviders' do
      allow(TeacherTrainingPublicAPI::SyncAllProviders).to receive(:call)

      described_class.new.perform

      expect(TeacherTrainingPublicAPI::SyncAllProviders).to have_received(:call)
    end
  end
end
