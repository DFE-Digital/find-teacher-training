module SelectOptionsHelper
  def select_provider_options
    cached_providers = TeacherTrainingPublicAPI::ProvidersCache.read
    return if cached_providers.blank?

    [OpenStruct.new(id: '', name: 'Select a provider')] + JSON.parse(cached_providers).map { |provider| OpenStruct.new(id: "#{provider['name']} (#{provider['code']})", name: "#{provider['name']} (#{provider['code']})") }
  end
end
