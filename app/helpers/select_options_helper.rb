module SelectOptionsHelper
  SelectProvider = Struct.new('SelectProvider', :id, :name)
  def select_provider_options
    cached_providers = TeacherTrainingPublicAPI::ProvidersCache.read
    return if cached_providers.blank?

    [SelectProvider.new('', 'Select a provider')] + JSON.parse(cached_providers).map { |provider| SelectProvider.new("#{provider['name']} (#{provider['code']})", "#{provider['name']} (#{provider['code']})") }
  end
end
