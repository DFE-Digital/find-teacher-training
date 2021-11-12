module HostingEnvironment
  def self.production?
    Rails.env.production?
  end

  def self.environment_name
    Rails.env
  end
end
