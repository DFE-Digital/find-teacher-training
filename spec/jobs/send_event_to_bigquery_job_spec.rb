require 'rails_helper'

RSpec.describe SendEventToBigqueryJob do
  include BigqueryTestHelper

  describe '#perform' do
    let(:request_event) do
      {
        environment: 'production',
        event_type: 'web_request',
        occured_at: Time.zone.now.iso8601,
        request_data: {
          method: 'GET',
          path: '/',
          status: 200,
          user_agent: 'testing agents',
        },
        request_uuid: '1c94ee0c-c217-4c45-a633-d649ff30a4c3',
      }
    end

    let(:table) { stub_bigquery_table }

    before do
      allow(table).to receive(:insert)
    end

    it 'sends request event JSON to Bigquery' do
      described_class.new.perform(request_event.as_json)

      expect(table).to have_received(:insert).with([request_event.as_json])
    end
  end
end
