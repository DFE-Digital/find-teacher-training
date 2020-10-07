require Rails.root.join("config/environments/production")
Rails.application.configure do
  # Logging
  config.log_level = :info
  config.rails_semantic_logger.format = :json
  config.semantic_logger.backtrace_level = :error
  config.semantic_logger.add_appender(io: STDOUT, level: config.log_level, formatter: config.rails_semantic_logger.format)

  config.logger = ActiveSupport::Logger.new(STDOUT)
end
