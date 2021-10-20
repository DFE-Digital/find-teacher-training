# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'action_controller/railtie'
require 'action_view/railtie'
require 'view_component/engine'
require './app/middleware/csharp_subject_conversion_middleware'
require './app/middleware/handle_bad_multipart_form_data_middleware'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module FindTeacherTraining
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.exceptions_app = routes

    config.time_zone = 'London'

    # https://thoughtbot.com/blog/content-compression-with-rack-deflater
    config.middleware.use Rack::Deflater
    config.middleware.use CsharpSubjectConversionMiddleware
    config.middleware.insert_before CsharpSubjectConversionMiddleware, HandleBadMultipartFormDataMiddleware

    config.skylight.environments = Settings.skylight_enable ? [Rails.env] : []

    config.active_job.queue_adapter = :sidekiq
    config.action_view.default_form_builder = GOVUKDesignSystemFormBuilder::FormBuilder
  end
end
