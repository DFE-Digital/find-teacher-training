def stub_teacher_training_api_resource(type:, resources:, params: {}, links: nil, fields: nil, include: nil, pagination: nil, search: nil, sort: nil)
  stub_teacher_training_api_request(
    api_url(type: type, params: params, fields: fields, include: include, pagination: pagination, search: search, sort: sort),
    resource_to_jsonapi(resources, include: include, links: links),
  )
end
