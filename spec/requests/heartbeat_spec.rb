require 'rails_helper'

describe 'heartbeat requests' do
  describe 'GET /ping' do
    it 'returns PONG' do
      get '/ping'

      expect(response.body).to eq 'PONG'
    end
  end

  describe 'GET /sha' do
    around :each do |example|
      ENV['SHA'] = 'some-sha'

      example.run
    end

    it 'returns sha' do
      get '/sha'
      expect(response).to be_successful
      expect(JSON.parse(response.body)).to eql({ 'sha' => 'some-sha' })
    end
  end

  describe 'GET /healthcheck' do
    let(:healthcheck_endpoint) { "#{Settings.teacher_training_api.base_url}/healthcheck" }

    context 'when everything is ok' do
      before do
        stub_request(:get, healthcheck_endpoint)
            .to_return(status: 200)
        get '/healthcheck'
      end

      it 'returns HTTP success' do
        expect(response.status).to eq(200)
      end

      it 'returns JSON' do
        expect(response.media_type).to eq('application/json')
      end

      it 'returns the expected response report' do
        expect(response.body).to eq({ checks: {
          teacher_training_api: true,
        } }.to_json)
      end
    end

    context 'when the api returns 503' do
      before do
        stub_request(:get, healthcheck_endpoint)
            .to_return(status: 503)
        get '/healthcheck'
      end

      it 'returns status service_unavailable' do
        expect(response.status).to eq(503)
      end

      it 'returns the expected response report' do
        expect(response.body).to eq({ checks: {
          teacher_training_api: false,
        } }.to_json)
      end
    end

    context 'when the api times out' do
      before do
        stub_request(:get, healthcheck_endpoint)
            .to_timeout
        get '/healthcheck'
      end

      it 'returns status service_unavailable' do
        expect(response.status).to eq(503)
      end

      it 'returns the expected response report' do
        expect(response.body).to eq({ checks: {
          teacher_training_api: false,
        } }.to_json)
      end
    end

    context 'when the api refuses the connection' do
      before do
        stub_request(:get, healthcheck_endpoint)
            .to_raise(StandardError) # https://stackoverflow.com/questions/25552239/webmock-simulate-failing-api-no-internet-timeout/25559291#25559291
        get '/healthcheck'
      end

      it 'returns status service_unavailable' do
        expect(response.status).to eq(503)
      end

      it 'returns the expected response report' do
        expect(response.body).to eq({ checks: {
          teacher_training_api: false,
        } }.to_json)
      end
    end
  end
end
