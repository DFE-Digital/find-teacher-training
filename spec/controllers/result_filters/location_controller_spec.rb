require 'rails_helper'

RSpec.describe ResultFilters::LocationController do
  include StubbedRequests::SubjectAreas

  describe '#start' do
    context 'when env is development and the Provider cache is empty' do
      it 'raises an error' do
        allow(Rails.env).to receive(:development?).and_return(true)
        allow(TeacherTrainingPublicAPI::ProvidersCache).to receive(:read).and_return('')

        expect { get :start }.to raise_error(ProviderCacheEmptyError)
      end
    end
  end
end
