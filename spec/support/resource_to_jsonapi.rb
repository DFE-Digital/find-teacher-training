def resource_to_jsonapi(resource, **opts)
  renderer = JSONAPI::Serializable::Renderer.new

  jsonapi = renderer.render(
    resource,
    class: {
      # This tells the renderer what serializers to use. The key is going
      # to be the name of the class as a symbol, and the value is the
      # serializer class.
      Course: CourseSerializer,
      Provider: ProviderSerializer,
      RecruitmentCycle: RecruitmentCycleSerializer,
      Site: SiteSerializer,
      SiteStatus: SiteStatusSerializer,
      Subject: SubjectSerializer,
    },
    include: opts[:include],
    meta: opts[:meta],
    links: opts[:links],
  )

  # Somehow, the JSONAPI Serializer reifies these objects as 'nil' if they
  # include an id with them. No idea why, so this hack is going to have to
  # suffice for now.
  jsonapi[:included]&.each { |data| data[:attributes].delete :id }
  jsonapi
end
