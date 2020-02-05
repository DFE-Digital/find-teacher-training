module FilterParameters
  def filter_params
    if request.method == "GET"
      parameters = request.query_parameters
    elsif request.method == "POST"
      parameters = request.request_parameters
    end

    custom_params = parameters.reject do |param|
      param.in? %w(utf8 authenticity_token)
    end

    custom_params_with_formatted_arrays = custom_params.to_h do |key, value|
      if value.is_a? Array
        [key, serialize_array_filter_param(value)]
      else
        [key, value]
      end
    end

    custom_params_with_formatted_arrays.with_indifferent_access
  end

  def deserialize_array_filter_param(param)
    params[param].split(",") if params.key?(param)
  end

  def serialize_array_filter_param(value)
    value.join(",") if value.present?
  end
end
