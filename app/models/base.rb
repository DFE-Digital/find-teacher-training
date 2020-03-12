class Base < JsonApiClient::Resource
  include Draper::Decoratable

  def run(request_method, path, params: nil, headers: {}, body: nil)
    super(
      request_method,
      path,
      params: params,
      headers: headers.update(
        "X-Request-Id" => RequestStore.store[:request_id],
        ),
      body: body
    )
  end

  self.site = "#{Settings.teacher_training_api.base_url}/api/v3/"
  self.paginator = JsonApiClient::Paginating::NestedParamPaginator
end
