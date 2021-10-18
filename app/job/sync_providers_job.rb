class SyncProvidersJob < ApplicationJob
  queue_as :sync_providers

  def perform
    TeacherTrainingPublicAPI::SyncAllProviders.call
  end
end
