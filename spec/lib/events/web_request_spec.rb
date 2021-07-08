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
    let(:referer)      { 'http://127.0.0.1/' }
    let(:query_string) { 'param=val' }
    let(:remote_ip)    { '10.0.0.1' }

    let(:rack_request) do
      instance_double(
        ActionDispatch::Request,
        path: path,
        method: method,
        user_agent: user_agent,
        uuid: uuid,
        referer: referer,
        query_string: query_string,
        remote_ip: remote_ip,
      )
    end
    let(:web_request) { Events::WebRequest.new.with_request_details(rack_request) }

    it 'sets request_uuid' do
      expect(web_request.as_json['request_uuid']).to eq uuid
    end

    it 'sets request path' do
      expect(web_request.as_json['request_path']).to eq path
    end

    it 'sets request method' do
      expect(web_request.as_json['request_method']).to eq method
    end

    it 'sets request user_agent' do
      expect(web_request.as_json['request_user_agent']).to eq user_agent
    end

    it 'sets request referer' do
      expect(web_request.as_json['request_referer']).to eq referer
    end

    it 'sets request params, converting to array' do
      expect(web_request.as_json['request_query']).to(
        eq([{ 'key' => 'param', 'value' => ['val'] }]),
      )
    end

    describe 'anonymised_user_agent_and_ip' do
      context 'when user agent and ip address both present' do
        it 'is set to a hash of user agent and ip' do
          expect(web_request.as_json['anonymised_user_agent_and_ip']).to(
            eq(Digest::SHA2.hexdigest(user_agent + remote_ip)),
          )
        end
      end

      context 'when user agent is present but ip address is blank' do
        let(:remote_ip) { nil }

        it 'is nil' do
          expect(web_request.as_json['anonymised_user_agent_and_ip']).to be_nil
        end
      end

      context 'when user agent is blank but ip address is present' do
        let(:user_agent) { nil }

        it 'is set to a hash of the ip' do
          expect(web_request.as_json['anonymised_user_agent_and_ip']).to(
            eq(Digest::SHA2.hexdigest(remote_ip)),
          )
        end
      end

      context 'when user agent and ip address are both blank' do
        let(:remote_ip) { nil }
        let(:user_agent) { nil }

        it 'is nil' do
          expect(web_request.as_json['anonymised_user_agent_and_ip']).to be_nil
        end
      end
    end

    context 'query string with array' do
      let(:query_string) { 'param=val&params[]=one&params[]=two' }

      it 'sets request params, converting to array' do
        expect(web_request.as_json['request_query']).to(
          eq([{ 'key' => 'param', 'value' => ['val'] },
              { 'key' => 'params[]', 'value' => %w[one two] }]),
        )
      end
    end
  end

  describe '#with_response_data' do
    let(:status) { instance_double(Integer) }
    let(:response) { instance_double(ActionDispatch::Response, status: status, content_type: content_type) }
    let(:content_type) { 'text/htnl' }
    let(:web_request) { Events::WebRequest.new.with_response_details(response) }

    it 'sets the response status' do
      expect(web_request.as_json['response_status']).to eq status.as_json
    end

    it 'sets the response content type' do
      expect(web_request.as_json['response_content_type']).to eq content_type
    end
  end
end
