module HostingEnvironment
  def self.production?
    Rails.env.production?
  end
end
