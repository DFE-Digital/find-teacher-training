require 'rails_helper'

RSpec.describe EmitRequestEvents, type: :request, with_bigquery: true do
  include BigqueryTestHelper

  let(:project) { instance_double(Google::Cloud::Bigquery::Project, dataset: dataset) }
  let(:dataset) { instance_double(Google::Cloud::Bigquery::Dataset, table: table) }
  let(:table) { stub_bigquery_table }

  before do
    allow(table).to receive(:insert)
  end

  context 'with send_web_requests_to_bigquery enabled' do
    before do
      activate_feature(:send_web_requests_to_bigquery)
    end

    it 'enqueues job to send event to bigquery' do
      get '/'

      expect(SendEventToBigqueryJob).to have_been_enqueued.exactly(:once)

      job_args = enqueued_jobs.last[:args]

      expect(job_args.first['event_type']).to eq('web_request')
    end
  end

  context 'with send_web_requests_to_bigquery disabled' do
    before do
      deactivate_feature(:send_web_requests_to_bigquery)
    end

    it 'does not enqueue any jobs' do
      get '/'

      expect(SendEventToBigqueryJob).not_to have_been_enqueued
    end
  end
end
