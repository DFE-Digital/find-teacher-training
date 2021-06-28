require 'rails_helper'

RSpec.describe 'viewing the root page' do
  include ActiveJob::TestHelper
  include BigQueryTestHelper

  it 'sends a web request event to BigQuery' do
    table = stub_big_query_table

    allow(table).to receive(:insert)

    activate_feature(:send_web_requests_to_big_query)

    request_uuid = SecureRandom.uuid

    page.driver.header 'USER_AGENT', 'test agent'
    page.driver.header 'X_REQUEST_ID', request_uuid
    page.driver.header 'REFERER', 'http://www.gov.uk'

    Timecop.freeze do
      visit '/' # , headers: { 'HTTP_USER_AGENT' => 'test user agent' }

      perform_enqueued_jobs

      expect(table).to(
        have_received(:insert).with(
          [{
            'environment' => 'test',
            'event_type' => 'web_request',
            'occurred_at' => Time.now.utc.iso8601,
            'request_method' => 'GET',
            'request_path' => '/',
            'request_user_agent' => 'test agent',
            'request_referer' => 'http://www.gov.uk',
            'request_uuid' => request_uuid,
            'response_content_type' => 'text/html; charset=utf-8',
            'response_status' => 200,
          }],
        ),
      )
    end
  end
end
