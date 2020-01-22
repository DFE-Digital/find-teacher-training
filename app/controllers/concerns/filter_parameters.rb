module FilterParameters
  def filter_params
    custom_params = request.request_parameters.reject do |param|
      param == "utf8"
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
