require 'rails_helper'

RSpec.describe 'viewing the root page' do
  include ActiveJob::TestHelper
  include BigqueryTestHelper

  it 'sends a web request event to BigQuery' do
    table = stub_bigquery_table

    allow(table).to receive(:insert)

    activate_feature(:send_web_requests_to_bigquery)

    request_uuid = SecureRandom.uuid

    page.driver.header 'USER_AGENT', 'test agent'
    page.driver.header 'X_REQUEST_ID', request_uuid

    Timecop.freeze do
      visit '/' # , headers: { 'HTTP_USER_AGENT' => 'test user agent' }

      perform_enqueued_jobs

      expect(table).to(
        have_received(:insert).with(
          [{
            'environment' => 'test',
            'event_type' => 'web_request',
            'occured_at' => Time.now.utc.iso8601,
            'request_data' => {
              'method' => 'GET',
              'path' => '/',
              'status' => 200,
              'user_agent' => 'test agent',
            },
            'request_uuid' => request_uuid,
          }],
        ),
      )
    end
  end
end
