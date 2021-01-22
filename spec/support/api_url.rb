def api_url(type:, params:, fields: nil, include: nil, pagination: nil, search: nil, sort: nil)
  query_params = {}
  unless fields.nil?
    query_params[:fields] = fields.to_h do |model_name, model_fields|
      [model_name, model_fields.join(',')]
    end
  end
  query_params[:include] = include.join(',') unless include.nil?
  query_params[:page] = pagination unless pagination.nil?
  query_params[:search] = search unless search.nil?
  query_params[:sort] = sort unless sort.nil?
  key = params[type.primary_key]

  url = "/#{type.path(**params)}"
  url += "/#{key}" unless key.nil?
  url += "?#{query_params.to_query}" unless query_params.empty?
  url
end
