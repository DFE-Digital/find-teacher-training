require 'rails_helper'

RSpec.describe EmitRequestEvents, type: :request, with_bigquery: true do
  context 'with send_web_requests_to_big_query enabled' do
    before do
      FeatureFlag.activate(:send_web_requests_to_big_query)
    end

    it 'enqueues job to send event to bigquery' do
      get '/'

      expect(SendEventToBigQueryJob).to have_been_enqueued.exactly(:once)

      job_args = enqueued_jobs.last[:args]

      expect(job_args.first['event_type']).to eq('web_request')
    end
  end

  context 'with send_web_requests_to_big_query disabled' do
    before do
      FeatureFlag.deactivate(:send_web_requests_to_big_query)
    end

    it 'does not enqueue any jobs' do
      get '/'

      expect(SendEventToBigQueryJob).not_to have_been_enqueued
    end
  end
end
