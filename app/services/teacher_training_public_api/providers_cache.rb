module TeacherTrainingPublicAPI
  class ProvidersCache
    def self.save(providers)
      Redis.current.set('providers', providers)
    end

    def self.read
      Redis.current.get('providers')
    end
  end
end
