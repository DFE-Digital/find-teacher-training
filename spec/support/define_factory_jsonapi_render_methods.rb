FactoryBot.define do
  # This defines an after build callback that goes on ALL factories.
  after :build do |record|
    # This defines an instance method called to_jsonapi on the object we just
    # created with the factory.
    record.define_singleton_method(:to_jsonapi) do |opts = {}|
      renderer = JSONAPI::Serializable::Renderer.new

      jsonapi = renderer.render(
        record,
        class: {
          # This tells the renderer what serializers to use. The key is going
          # to be the name of the class as a symbol, and the value is the
          # serializer class.
          #
          # For example: User: CourseSerializer
          # This is done in two places, perhaps they should be unified?
          Course: CourseSerializer,
          Provider: ProviderSerializer,
          RecruitmentCycle: RecruitmentCycleSerializer,
        },
        include: opts[:include],
      )

      # Somehow, the JSONAPI Serializer reifies these objects as 'nil' if they
      # include an id with them. No idea why, so this hack is going to have to
      # suffice for now.
      jsonapi[:included]&.each { |data| data[:attributes].delete :id }
      jsonapi
    end
  end
end
