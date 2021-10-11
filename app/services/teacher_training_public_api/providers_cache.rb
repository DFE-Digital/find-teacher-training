module TeacherTrainingPublicAPI
  class ProvidersCache
    def self.save(providers)
      RedisService.current.set('providers', providers)
    end

    def self.read
      RedisService.current.get('providers')
    end
  end
end
