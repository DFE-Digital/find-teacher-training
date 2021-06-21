require 'google/cloud/bigquery'

BIG_QUERY_API_JSON_KEY = ENV['BIG_QUERY_API_JSON_KEY']

if FeatureFlag.active?(:send_web_requests_to_bigquery)
  Google::Cloud::Bigquery.configure do |config|
    config.project_id  = Settings.google.big_query_project_id
    config.credentials = JSON.parse(BIG_QUERY_API_JSON_KEY)
  end

  Google::Cloud::Bigquery.new
end
