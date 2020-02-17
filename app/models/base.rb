class Base < JsonApiClient::Resource
  include Draper::Decoratable

  self.site = "#{Settings.teacher_training_api.base_url}/api/v3/"
  self.paginator = JsonApiClient::Paginating::NestedParamPaginator
end
