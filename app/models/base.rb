class Base < JsonApiClient::Resource
  class MCBConnection < JsonApiClient::Connection
    def run(request_method, path, params: nil, headers: {}, body: nil)
      super(
        request_method,
        path,
        params: params,
        body: body
      )
    end
  end
  
  self.site = "#{Settings.manage_backend.base_url}/api/v3/"
  self.connection_class = MCBConnection

private

  def post_request(path)
    post_options = {
      body: { data: { attributes: {}, type: self.class.to_s.downcase } },
      params: request_params.to_params,
    }

    self.last_result_set = self.class.requestor.__send__(
      :request, :post, post_base_url + path, post_options
    )

    if last_result_set.has_errors?
      self.fill_errors # Inherited from JsonApiClient::Resource
      false
    else
      self.errors.clear if self.errors
      true
    end
  end
end
