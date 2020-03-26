module FilterParameters
  PREVIOUS_PARAMETER_PREFIX = "prev_".freeze

  def filter_params
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

  def filter_params_without_previous_parameters
    remove_previous_parameters(filter_params)
  end

  def merge_previous_parameters(all_parameters)
    previous_parameters.each do |key, value|
      next if value == "none"

      all_parameters[key.delete_prefix(PREVIOUS_PARAMETER_PREFIX)] = value
    end

    remove_previous_parameters(all_parameters)
  end

private

  def serialize_array_filter_param(value)
    value.join(",") if value.present?
  end

  def parameters
    return request.query_parameters if %w(GET HEAD).include?(request.method)

    request.request_parameters
  end

  def previous_parameters
    parameters.select { |key, _value| key.start_with? PREVIOUS_PARAMETER_PREFIX }
  end

  def remove_previous_parameters(all_parameters)
    all_parameters.reject { |key, _value| key.start_with? PREVIOUS_PARAMETER_PREFIX }
  end
end
