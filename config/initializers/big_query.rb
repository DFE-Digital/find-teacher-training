require 'google/cloud/bigquery'

BIG_QUERY_API_JSON_KEY = ENV['BIG_QUERY_API_JSON_KEY']

if FeatureFlag.active?(:send_web_requests_to_big_query)
  # Validate that the JSON key exists and that it is parseable.
  raise 'BigQuery JSON key missing. Disable feature if not sending events to BigQuery.' if BIG_QUERY_API_JSON_KEY.blank?

  Google::Cloud::Bigquery.configure do |config|
    # This command doesn't actually connect to BigQuery to check authorisation.
    config.credentials = JSON.parse(BIG_QUERY_API_JSON_KEY)
  end

  Google::Cloud::Bigquery.new
end
