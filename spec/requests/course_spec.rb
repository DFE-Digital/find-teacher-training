require 'rails_helper'

describe '/course' do
  context 'a request with the incorrect format' do
    it 'returns the 404 page in html format' do
      stub_request(:get, /#{Settings.teacher_training_api.base_url}/)
        .to_return(status: 404, body: '', headers: {})

      get '/course/fonts/Roboto-Regular.ttf'

      expect(response).to have_http_status(:not_found)
      expect(response.media_type).to eq('text/html')
    end
  end
end
