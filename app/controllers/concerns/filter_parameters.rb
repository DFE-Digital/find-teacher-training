module FilterParameters
  def filter_params
    custom_params = request.request_parameters.reject do |param|
      param.in? %w(utf8 authenticity_token)
    end

    custom_params_with_formatted_arrays = custom_params.to_h do |key, value|
      if value.is_a? Array
        [key, value.join(",")]
      else
        [key, value]
      end
    end

    custom_params_with_formatted_arrays.with_indifferent_access
  end
end
