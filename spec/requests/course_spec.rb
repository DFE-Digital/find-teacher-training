require 'rails_helper'

describe '/course', type: :request do
  context 'a request with the incorrect format' do
    it 'returns the 404 page in html format' do
      stub_request(:get, /#{Settings.teacher_training_api.base_url}/)
        .to_return(status: 404, body: '', headers: {})

      get '/course/fonts/Roboto-Regular.ttf'

      expect(response.status).to eq(404)
      expect(response.media_type).to eq('text/html')
    end
  end
end
