if Settings.logstash.host && Settings.logstash.port
  LogStashLogger.configure do |config|
    config.customize_event do |event|
      event["application"] = Settings.application_name
      event["environment"] = Rails.env
    end
  end
end
