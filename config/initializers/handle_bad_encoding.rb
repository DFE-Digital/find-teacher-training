require "rack/handle_bad_encoding"

Rails.application.config.middleware.use Rack::HandleBadEncoding
