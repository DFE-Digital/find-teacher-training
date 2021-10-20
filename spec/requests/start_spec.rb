require 'rails_helper'

describe '/start', type: :request do
  let(:cached_providers_data_qa_attr) { 'cached-providers-autocomplete' }

  it "redirects from '/start/location' to '/'" do
    get '/start/location'

    expect(response).to redirect_to('/')
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

    it 'is present when there are providers stored in the cache' do
      allow(TeacherTrainingPublicAPI::ProvidersCache).to receive(:read).and_return(cached_providers)

      get '/'

      expect(response.body).to include(cached_providers_data_qa_attr)
    end

    it 'is not present when there are no cached providers' do
      allow(TeacherTrainingPublicAPI::ProvidersCache).to receive(:read).and_return(nil)

      get '/'

      expect(response.body).not_to include(cached_providers_data_qa_attr)
    end
  end
end
