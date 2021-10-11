require 'rails_helper'

describe '/start', type: :request do
  let(:provider_autocomplete_container_div) { '<div id="provider-autocomplete" class="govuk-body"></div>' }
  let(:cached_providers_data_qa_attr) { 'cached-providers-autocomplete' }

  it "redirects from '/start/location' to '/'" do
    get '/start/location'

    expect(response).to redirect_to('/')
  end

  describe 'provider autocomplete' do
    it 'is present when provider_autocomplete feature flag is active' do
      activate_feature(:provider_autocomplete)

      get '/'

      expect(response.body).to include(provider_autocomplete_container_div)
      expect(response.body).not_to include(cached_providers_data_qa_attr)
    end

    it 'is not present when provider_autocomplete feature flag is inactive' do
      deactivate_feature(:provider_autocomplete)
      get '/'

      expect(response.body).not_to include(provider_autocomplete_container_div)
      expect(response.body).not_to include(cached_providers_data_qa_attr)
    end
  end

  describe 'cached provider autocomplete' do
    let(:cached_providers) {
      [
        {
          name: 'Provider 1',
          code: 'ABC',
        },
      ].to_json
    }

    it 'is present when cached provider feature flag is active and there are providers stored in the cache' do
      allow(TeacherTrainingPublicAPI::ProvidersCache).to receive(:read).and_return(cached_providers)
      activate_feature(:cache_providers)

      get '/'

      expect(response.body).to include(cached_providers_data_qa_attr)
    end

    it 'is not present when provider_autocomplete feature flag is inactive' do
      deactivate_feature(:cached_providers)
      allow(TeacherTrainingPublicAPI::ProvidersCache).to receive(:read).and_return(cached_providers)

      get '/'

      expect(response.body).not_to include(cached_providers_data_qa_attr)
    end

    it 'is not present when there are no cached providers' do
      activate_feature(:cache_providers)
      allow(TeacherTrainingPublicAPI::ProvidersCache).to receive(:read).and_return(nil)

      get '/'

      expect(response.body).not_to include(cached_providers_data_qa_attr)
    end
  end
end
