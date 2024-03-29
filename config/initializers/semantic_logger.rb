Rails.application.configure do
  config.semantic_logger.application = Settings.application_name
  config.log_tags = [:request_id] # Prepend all log lines with the following tags.
  config.log_level = Settings.log_level
end

SemanticLogger.add_appender(io: STDOUT, level: Rails.application.config.log_level, formatter: Rails.application.config.log_format)
Rails.application.config.logger.info('Application logging to STDOUT')
