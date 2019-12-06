# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.6.1"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 6.0.0"

# Use Puma as the app server
gem "puma", "~> 4.3"

# Use Uglifier as compressor for JavaScript assets
gem "uglifier", ">= 1.3.0"

# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem "webpacker"

gem "sprockets", "3.7.2"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.1.0", require: false

# Manage multiple processes i.e. web server and webpack
gem "foreman"

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

# Error tracking
gem "sentry-raven"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: %i[mri mingw x64_mingw]

  # GOV.UK interpretation of rubocop for linting Ruby
  gem "govuk-lint"

  # Factories to build models
  gem "factory_bot_rails"

  # Debugging
  gem "pry-byebug"

  # Testing framework
  gem "rspec-rails", "~> 4.0.0.beta2"
end

group :development do
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

  gem "selenium-webdriver"
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem "chromedriver-helper"

  # Get us some fake!
  gem "faker"

  # Page object for Capybara
  gem "site_prism"

  # Mock external requests
  gem "webmock"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
