# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.6.5"

# App Insights for Azure
gem "application_insights"
gem "pkg-config", "~> 1.4.4"

# Decorate logic to keep it of the views and helper methods
gem "draper"

# http client
gem "httparty"

# Offshore logging
gem "logstash-logger"

# Semantic Logger makes logs pretty
gem "rails_semantic_logger"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 6.0.3"

# Thread-safe global state
gem "request_store"

# Use Puma as the app server
gem "puma", "~> 5.0"

# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem "webpacker"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.1.0", require: false

# Manage multiple processes i.e. web server and webpack
gem "foreman"

# Geocoding
gem "geocoder"

# Kaminari, pagination templating
gem "kaminari"

# Canonical meta tag
gem "canonical-rails"

# Parsing JSON from an API
gem "json_api_client"

# Ability to render JSONAPI
gem "jsonapi-deserializable"
gem "jsonapi-renderer"
gem "jsonapi-serializable"

# Settings for the app
gem "config"

# Calculate distance between two locations
gem "geokit"

# Error tracking
gem "sentry-raven"

# Render nice markdown
gem "redcarpet"

# Render smart quotes
gem "rubypants"

# Monitoring
gem "skylight"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: %i[mri mingw x64_mingw]

  # Better use of test helpers such as save_and_open_page/screenshot
  gem "launchy"

  # GOV.UK interpretation of rubocop for linting Ruby
  gem "rubocop-govuk"
  gem "scss_lint-govuk"

  # Factories to build models
  gem "factory_bot_rails"

  # Debugging
  gem "pry-byebug"

  # Testing framework
  gem "rspec-rails", "~> 4.0.1"
end

group :development do
  # For better errors
  gem "better_errors"
  gem "binding_of_caller"

  # Static analysis
  gem "brakeman"

  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "listen", ">= 3.0.5", "< 3.3"
  gem "web-console", ">= 3.3.0"

  # Add Junit formatter for rspec
  gem "rspec_junit_formatter"

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 2.15"

  gem "webdrivers", "~> 4.4"

  # Get us some fake!
  gem "faker"

  # Show test coverage %
  gem "simplecov", "< 0.18", require: false

  # Page object for Capybara
  gem "site_prism"

  # Mock external requests
  gem "webmock"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
