def stub_api_v3_resource(type:, resources:, params: {}, links: nil, fields: nil, include: nil, pagination: nil, search: nil, sort: nil)
  stub_api_v3_request(
    api_v3_url(type:, params:, fields:, include:, pagination:, search:, sort:),
    resource_to_jsonapi(resources, include:, links:),
  )
end
