class Base < JsonApiClient::Resource
  include Draper::Decoratable

  self.site = "#{Settings.manage_backend.base_url}/api/v3/"
  self.paginator = JsonApiClient::Paginating::NestedParamPaginator
end
