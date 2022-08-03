module TeacherTrainingPublicAPI
  class SyncAllProviders
    def self.call(recruitment_cycle_year: ::RecruitmentCycle.current_year)
      response = Provider
        .select(:provider_code, :provider_name)
        .where(recruitment_cycle_year:)
        .all

      sync_providers(providers_from_api: response)

      TeacherTrainingPublicAPI::SyncCheck.set_last_sync(Time.zone.now)
    rescue JsonApiClient::Errors::ApiError
      raise TeacherTrainingPublicAPI::SyncError
    end

    def self.sync_providers(providers_from_api:)
      providers = providers_from_api.map do |provider_from_api|
        {
          name: provider_from_api.provider_name,
          code: provider_from_api.provider_code,
        }
      end

      TeacherTrainingPublicAPI::ProvidersCache.save(providers.to_json)
    end

    private_class_method :sync_providers
  end
end
