DfE::Analytics.configure do |config|
  config.log_only = false

  # Whether to use ActiveJob or dispatch events immediately.
  #
  config.async = true

  # The name of the BigQuery table we’re writing to.
  #
  config.bigquery_table_name = Settings.google.big_query.table_name

  # The name of the BigQuery project we’re writing to.
  #
  config.bigquery_project_id = Settings.google.big_query.project_id

  # The name of the BigQuery dataset we're writing to.
  #
  config.bigquery_dataset = Settings.google.big_query.dataset

  # Service account JSON key for the BigQuery API. See
  # https://cloud.google.com/bigquery/docs/authentication/service-account-file
  #
  # config.bigquery_api_json_key = ENV['BIGQUERY_API_JSON_KEY']
  config.bigquery_api_json_key = ENV.fetch('BIG_QUERY_API_JSON_KEY', nil)

  # A proc which returns true or false depending on whether you want to
  # enable analytics. You might want to hook this up to a feature flag or
  # environment variable.
  #
  config.enable_analytics = proc { FeatureFlag.active?(:send_web_requests_to_big_query) }

  # The environment we’re running in. This value will be attached
  # to all events we send to BigQuery.
  #
  # config.environment = ENV.fetch('RAILS_ENV', 'development')
end
