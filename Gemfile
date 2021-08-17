# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

gem 'pkg-config', '~> 1.4.6'

# Decorate logic to keep it of the views and helper methods
gem 'draper'

# http client
gem 'httparty'

# Semantic Logger makes logs pretty
gem 'rails_semantic_logger'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1.4'

# Thread-safe global state
gem 'request_store'

gem 'puma', '~> 5.4'

# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker'

# Use the GOV UK form builder
gem 'govuk_design_system_formbuilder', '~> 2.7.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Manage multiple processes i.e. web server and webpack
gem 'foreman'

# Geocoding
gem 'geocoder'

# Kaminari, pagination templating
gem 'kaminari'

# Canonical meta tag
gem 'canonical-rails'

# Parsing JSON from an API
gem 'json_api_client'

# Ability to render JSONAPI
gem 'jsonapi-deserializable'
gem 'jsonapi-renderer'
gem 'jsonapi-serializable'

# Validate JSON schema
gem 'json-schema'

# Settings for the app
gem 'config'

gem 'redis', '~> 4.4'

# Calculate distance between two locations
gem 'geokit'

# Error tracking
gem 'sentry-raven'

# Render nice markdown
gem 'redcarpet'

# Render smart quotes
gem 'rubypants'

# Monitoring
gem 'skylight'

# Allows the creation of components which encapsulate and test logic in views
gem 'view_component'
gem 'govuk-components'

# Data integration with BigQuery
gem 'google-cloud-bigquery'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]

  # Better use of test helpers such as save_and_open_page/screenshot
  gem 'launchy'

  gem 'rubocop'
  gem 'rubocop-rspec'
  gem 'rubocop-rails'
  gem 'rubocop-rake'
  gem 'scss_lint-govuk'
  gem 'erb_lint', require: false

  # Factories to build models
  gem 'factory_bot_rails'

  # Debugging
  gem 'pry-byebug'

  # Testing framework
  gem 'rspec-rails', '~> 5.0.2'
end

group :development do
  # For better errors
  gem 'better_errors'
  gem 'binding_of_caller'

  # Static analysis
  gem 'brakeman'

  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.7'
  gem 'web-console', '>= 3.3.0'

  # Add Junit formatter for rspec
  gem 'rspec_junit_formatter'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'

  gem 'webdrivers', '~> 4.6'

  # Get us some fake!
  gem 'faker'

  # Show test coverage %
  gem 'simplecov', '< 0.18', require: false

  # Page object for Capybara
  gem 'site_prism'

  # Mock external requests
  gem 'webmock'

  # Control time
  gem 'timecop'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
