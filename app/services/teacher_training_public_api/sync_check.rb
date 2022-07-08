module TeacherTrainingPublicAPI
  class SyncCheck
    LAST_SUCCESSFUL_SYNC = 'last-successful-sync-with-teacher-training-api'.freeze

    # rubocop:disable Naming/AccessorMethodName
    def self.set_last_sync(time)
      RedisService.current.set(LAST_SUCCESSFUL_SYNC, time)
    end
    # rubocop:enable Naming/AccessorMethodName

    def self.last_sync
      RedisService.current.get(LAST_SUCCESSFUL_SYNC)
    end
  end
end
