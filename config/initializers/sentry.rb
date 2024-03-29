# https://docs.sentry.io/clients/ruby/config
Sentry.init do |config|
  config.environment = Rails.env
  config.release = ENV.fetch('SHA', nil)

  # > Inspect an incoming exception's causes when determining whether or not that
  # exception should be excluded
  #
  # This will also exclude exceptions like `ActionView::Template::Error` if
  # they're caused by `JsonApiClient::Errors::ConnectionError`, like
  # https://sentry.io/organizations/dfe-bat/issues/1845349352
  config.inspect_exception_causes_for_exclusion = true

  config.excluded_exceptions += [
    'ActionController::BadRequest',
    'JsonApiClient::Errors::ConnectionError',
    'URI::InvalidURIError',
    'Mime::Type::InvalidMimeType',
  ]
end
