require 'rails_helper'

RSpec.describe Events::WebRequest do
  describe '#as_json' do
    it 'returns a JSON-friendly version of the web request' do
      web_request = Events::WebRequest.new

      expect(web_request.as_json).to be_a Hash
    end
  end

  describe 'initialisation' do
    it 'sets the event_type to web_request' do
      web_request = Events::WebRequest.new

      expect(web_request.as_json['event_type']).to eq 'web_request'
    end

    it 'sets the occurred_at to now' do
      Timecop.freeze('2021-06-16 12:00:00') do
        web_request = Events::WebRequest.new

        expect(web_request.as_json['occurred_at']).to eq '2021-06-16T12:00:00Z'
      end
    end

    it 'sets the environment to the rails env' do
      rails_env = object_double(Rails.env)
      allow(Rails).to receive(:env).and_return(rails_env)

      web_request = Events::WebRequest.new

      expect(web_request.as_json['environment']).to eq rails_env.as_json
    end
  end

  describe '#with_request_details' do
    let(:path)         { '/some_path' }
    let(:method)       { 'GET' }
    let(:user_agent)   { 'not real test user agent' }
    let(:uuid)         { '19bd4d16-da8f-46ed-b211-874eeac377bd' }

    let(:rack_request) { instance_double(ActionDispatch::Request, path: path, method: method, user_agent: user_agent, uuid: uuid) }
    let(:web_request)  { Events::WebRequest.new.with_request_details(rack_request) }

    it 'sets request_uuid' do
      expect(web_request.as_json['request_uuid']).to eq uuid
    end

    it 'sets request path' do
      expect(web_request.as_json['request_data']['path']).to eq path
    end

    it 'sets request method' do
      expect(web_request.as_json['request_data']['method']).to eq method
    end

    it 'sets request user_agent' do
      expect(web_request.as_json['request_data']['user_agent']).to eq user_agent
    end
  end

  describe '#with_response_data' do
    it 'sets the response status' do
      status = instance_double(Integer)
      response = instance_double(ActionDispatch::Response, status: status)
      web_request = Events::WebRequest.new.with_response_details(response)

      expect(web_request.as_json['request_data']['status']).to eq status.as_json
    end
  end
end
