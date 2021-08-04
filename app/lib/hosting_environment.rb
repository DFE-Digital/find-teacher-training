module HostingEnvironment
  def self.environment_name
    ENV.fetch('HOSTING_ENVIRONMENT_NAME', 'unknown-environment')
  end

  def self.production?
    environment_name == 'production'
  end
end
