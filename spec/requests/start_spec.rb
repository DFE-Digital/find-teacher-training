require 'rails_helper'

describe '/start', type: :request do
  it "redirects from '/start/location' to '/'" do
    get '/start/location'

    expect(response).to redirect_to('/')
  end

  describe 'provider autocomplete' do
    let(:container_div) { '<div id="provider-autocomplete" class="govuk-body"></div>' }

    it 'is present when provider_autocomplete feature flag is active' do
      activate_feature(:provider_autocomplete)
      get '/'

      expect(response.body).to include(container_div)
    end

    it 'is not present when provider_autocomplete feature flag is inactive' do
      deactivate_feature(:provider_autocomplete)
      get '/'

      expect(response.body).not_to include(container_div)
    end
  end
end
