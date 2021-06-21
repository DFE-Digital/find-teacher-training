require 'rails_helper'

RSpec.describe SendEventToBigqueryJob do
  describe '#perform' do
    let(:request_event) do
      {
        environment: 'production',
        request_method: 'GET',
        request_path: '/',
        request_uuid: '1c94ee0c-c217-4c45-a633-d649ff30a4c3',
        timestamp: Time.zone.now.iso8601,
        user_agent: 'testing agents',
      }
    end

    let(:project) { instance_double(Google::Cloud::Bigquery::Project, dataset: dataset) }
    let(:dataset) { instance_double(Google::Cloud::Bigquery::Dataset, table: table) }
    let(:table) { instance_double(Google::Cloud::Bigquery::Table) }

    before do
      allow(Google::Cloud::Bigquery).to receive(:new).and_return(project)
      allow(table).to receive(:insert)
      allow(ENV).to receive(:fetch).with('BIG_QUERY_PROJECT_ID').and_return('bat-apply-test')
      allow(ENV).to receive(:fetch).with('BIG_QUERY_DATASET').and_return('bat-apply-test-events')
    end

    it 'sends request event JSON to Bigquery' do
      described_class.new.perform(request_event.as_json)

      expect(table).to have_received(:insert).with([request_event.as_json])
    end
  end
end
