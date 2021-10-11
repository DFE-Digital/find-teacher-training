module SelectOptionsHelper
  def select_provider_options
    provider_options = JSON.parse(TeacherTrainingPublicAPI::ProvidersCache.read)

    if provider_options
      [OpenStruct.new(id: '', name: 'Select a provider')] + provider_options.map { |provider| OpenStruct.new(id: "#{provider['name']} (#{provider['code']})", name: "#{provider['name']} (#{provider['code']})") }
    end
  end
end
